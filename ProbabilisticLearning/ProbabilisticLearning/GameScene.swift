//
//  GameScene.swift
//  ProbabilisticLearning
//
//  Created by Bryce Sandlund on 3/28/18.
//  Copyright © 2018 Bryce Sandlund. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

// Logic for experiment is in this file
class GameScene: SKScene {
    // Scene objects
    private var leftTree : SKSpriteNode?
    private var rightTree : SKSpriteNode?
    private var background : SKSpriteNode?
    private var leftCat : SKSpriteNode?
    private var rightCat : SKSpriteNode?
    private var middleCat : SKSpriteNode?
    private var touchToBegin : SKLabelNode?
    var backToStartButton : UIButton?
    var hideButton : UIButton?
    
    // Settings from GameViewController, and delegate to segue from GameViewController
    var gameDelegate: GameDelegate?
    var runSettings : RunSettings!
    
    // Instance variables
    private var runNumber = 0
    private var pauseInteraction = true
    private var lastAction : Date = Date()
    private var first = true
    
    // constants
    private static let catInTreeTime : TimeInterval = 1
    private static let catInFrontTime : TimeInterval = 1
    private static let beginningFrontTime : TimeInterval = 2
    private static let fadeOutTime : TimeInterval = 0.5
    private static let showButtonDelay : TimeInterval = 1.5
    private static let shakeDuration : TimeInterval = 0.25
    
    private static let correctSound = "Ding.wav"
    private static let incorrectSound = "Chime.wav"
    
    // Called at the beginning and after every trial to setup the cat animation stuff
    private func setupTrial(beginning : Bool) {
        // This is set twice if not the beginning, but shouldn't hurt
        self.pauseInteraction = true
        
        let wait1 = SKAction.wait(forDuration: GameScene.catInTreeTime)
        let wait2 = SKAction.wait(forDuration: GameScene.catInFrontTime)
        let wait3 = SKAction.wait(forDuration: GameScene.beginningFrontTime)
        let unhide = SKAction.fadeIn(withDuration: 0)   // necessary to fade in when fading out
        let fadeOut = SKAction.fadeOut(withDuration: GameScene.fadeOutTime)
        
        // Code block after middle cat disappears
        let unpause = SKAction.run {
            self.pauseInteraction = false
            self.lastAction = Date()
        }
        
        var sequence : SKAction
        if (!beginning) {
            sequence = SKAction.sequence([wait1, unhide, wait2, fadeOut, unpause])
        }
        else {
            sequence = SKAction.sequence([unhide, wait3, fadeOut, unpause])
        }
        
        middleCat?.run(sequence)
    }
    
    // use this function to instantiate the view with any info
    override func didMove(to view: SKView) {
        // set variables with what's in GameScene.sks
        self.leftTree = self.childNode(withName: "//leftTree") as? SKSpriteNode
        self.rightTree = self.childNode(withName: "//rightTree") as? SKSpriteNode
        self.background = self.childNode(withName: "//background") as? SKSpriteNode
        self.leftCat = self.childNode(withName: "//leftCat") as? SKSpriteNode
        self.rightCat = self.childNode(withName: "//rightCat") as? SKSpriteNode
        self.middleCat = self.childNode(withName: "//middleCat") as? SKSpriteNode
        self.touchToBegin = self.childNode(withName: "//touchToBegin") as? SKLabelNode
        
        // hide stuff
        leftCat?.isHidden = true
        rightCat?.isHidden = true
        middleCat?.alpha = 0    // same as fading out immediately, will hide it
        
        background?.size = self.frame.size  // not sure if this is doing anything
    }
    
    // called when the back to start button has started being held, or end of trials
    func showBackToStart() {
        let wait1 = SKAction.wait(forDuration: GameScene.showButtonDelay)
        let makeVisible = SKAction.run {
            self.backToStartButton?.isHidden = false
            if (self.runNumber < self.runSettings.catIsLeft.count) {
                self.hideButton?.isHidden = false
            }
        }
        let sequence = SKAction.sequence([wait1, makeVisible])
        // running on background since it can be run on any object
        background?.run(sequence)
    }
    
    // called when back to start button should hide
    func hideButtonLogic() {
        if (backToStartButton?.isHidden == true && runNumber < runSettings.catIsLeft.count) {
            background?.removeAllActions()
        }
    }
    
    // detects the touch and does the cat stuff accordingly
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (first) {
            first = false
            // do middle cat stuff, beginning true this time!
            self.touchToBegin?.isHidden = true
            setupTrial(beginning: true)
        }
        
        // detect if left or right tree has been touched
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        
        // values chosen by printing the coordinates
        if (positionInScene.x >= 291.5 && positionInScene.y <= -295) {
            print("touching backToStart")
            showBackToStart()
        }
        else {
            hideButtonLogic()
        }
        
        // ignore tree touches if in the middle of cat animation
        if (!pauseInteraction) {
            let touchedNodes = self.nodes(at: positionInScene)
            
            var pickedLeft = false
            var pickedRight = false
            
            for node in touchedNodes {
                if node.name == leftTree?.name {
                    print("touched left")
                    pickedLeft = true
                }
                else if node.name == rightTree?.name {
                    print("touched right")
                    pickedRight = true
                }
            }
            
            if (pickedLeft || pickedRight) {
                // pause until unpaused via setupTrial
                self.pauseInteraction = true
                
                // Actions for cat that is revealed
                let wait1 = SKAction.wait(forDuration: GameScene.catInTreeTime)
                let wait2 = SKAction.wait(forDuration: GameScene.catInTreeTime - GameScene.shakeDuration)
                let reveal = SKAction.unhide()
                let hide = SKAction.hide()
                let shake = getShakeAction(duration: GameScene.shakeDuration)
                var sequence : SKAction
                let correctSound = SKAction.playSoundFileNamed(GameScene.correctSound, waitForCompletion: false)
                let incorrectSound = SKAction.playSoundFileNamed(GameScene.incorrectSound, waitForCompletion: false)
                
                var correct : Bool
                // correct!
                if (pickedLeft && runSettings.catIsLeft[runNumber] || pickedRight && !runSettings.catIsLeft[runNumber]) {
                    correct = true
                    sequence = SKAction.sequence([reveal, correctSound, wait1, hide])
                }
                else {  // incorrect D:
                    correct = false
                    sequence = SKAction.sequence([reveal, incorrectSound, /*shake, wait2,*/wait1, hide])
                }
                
                if (runSettings.catIsLeft[runNumber]) {
                    leftCat?.run(sequence)
                }
                else {
                    rightCat?.run(sequence)
                }
                
                // possibly record trial. Handled by RunSettings/ TrialRunSettings subclassing
                runSettings.recordTrial(correct: correct, RT: Double(Date().timeIntervalSince(lastAction)))
                
                runNumber += 1
                
                // this call signals the middle cat to do its sequence if not last trial
                if (runNumber < runSettings.catIsLeft.count) {
                    setupTrial(beginning: false)
                }
                
                if (runNumber == runSettings.catIsLeft.count) {
                    print("runs equal")
                    showBackToStart()
                }
            }
        }
    }
    
    // return the makeshift shake action when choice is wrong
    func getShakeAction(duration: TimeInterval) -> SKAction {
        let amplitudeX:Float = 45;
        let amplitudeY:Float = 45;
        let numberOfShakes = duration / 0.02;
        var actionsArray:[SKAction] = [];
        for _ in 1...Int(numberOfShakes) {
            let moveX = Float(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2;
            let moveY = Float(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2;
            let shakeAction = SKAction.moveBy(x: CGFloat(moveX), y: CGFloat(moveY), duration: 0.01);
            shakeAction.timingMode = SKActionTimingMode.easeOut;
            actionsArray.append(shakeAction);
            actionsArray.append(shakeAction.reversed());
        }
        return SKAction.sequence(actionsArray)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //    for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideButtonLogic()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    //    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
