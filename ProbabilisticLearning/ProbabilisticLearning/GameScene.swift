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

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    private var leftTree : SKSpriteNode?
    private var rightTree : SKSpriteNode?
    private var background : SKSpriteNode?
    private var leftCat : SKSpriteNode?
    private var rightCat : SKSpriteNode?
    private var middleCat : SKSpriteNode?
    
    var gameDelegate: GameDelegate?
    var runSettings : RunSettings!
    // change to being able to do 70/30
    
    // play sound when correct and sound when incorrect
    var correctSound: AVAudioPlayer?
    var incorrectSound: AVAudioPlayer?
    
    private var runNumber = 0
    private var pauseInteraction = true
    
    private static let catInTreeTime : TimeInterval = 4
    private static let catInFrontTime : TimeInterval = 2
    private static let beginningFrontTime : TimeInterval = 5
    private static let fadeOutTime : TimeInterval = 1
    
    // Called at the beginning and after every trial to setup the cat animation stuff
    private func setupTrial(beginning : Bool) {
        self.pauseInteraction = true
        let wait1 = SKAction.wait(forDuration: GameScene.catInTreeTime)
        let wait2 = SKAction.wait(forDuration: GameScene.catInFrontTime)
        let wait3 = SKAction.wait(forDuration: GameScene.beginningFrontTime)
        let unhide = SKAction.fadeIn(withDuration: 0)
        let fadeOut = SKAction.fadeOut(withDuration: GameScene.fadeOutTime)
        let unpause = SKAction.run {
            self.pauseInteraction = false
        }
        
        var sequence : SKAction
        if (!beginning) {
            sequence = SKAction.sequence([wait1, unhide, wait2, fadeOut, unpause])
        }
        else {
            sequence = SKAction.sequence([wait3, fadeOut, unpause])
        }
        
        middleCat?.run(sequence)
    }
    
    // use this function to instantiate the view with any info
    override func didMove(to view: SKView) {
        
        self.leftTree = self.childNode(withName: "//leftTree") as? SKSpriteNode
        self.rightTree = self.childNode(withName: "//rightTree") as? SKSpriteNode
        self.background = self.childNode(withName: "//background") as? SKSpriteNode
        self.leftCat = self.childNode(withName: "//leftCat") as? SKSpriteNode
        self.rightCat = self.childNode(withName: "//rightCat") as? SKSpriteNode
        self.middleCat = self.childNode(withName: "//middleCat") as? SKSpriteNode
        
        leftCat?.isHidden = true
        rightCat?.isHidden = true
        
        setupTrial(beginning: true)
        
        background?.size = self.frame.size  // not sure if this is doing anything
        
        // This was an attempt to reduce the lag from the initial sound. Doesn't seem to help unfortunately
        correctSound = returnAudioPlayer(name: "Ding", ext: "wav")
        incorrectSound = returnAudioPlayer(name: "WrongBuzzer", ext: "mp3")
    }
    
    func returnAudioPlayer(name: String, ext: String) -> AVAudioPlayer? {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            return nil
        }
        do {
            return try AVAudioPlayer(contentsOf: url)
        } catch {
            return nil
        }
    }
    
    // Another method to play sound that works just as well, but I feel the above way is more as it was designed.
    /*func playSound(name: String, ext: String) {
        print("trying a sound")
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("resource not found")
            return
        }
        do {
            //try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            //try AVAudioSession.sharedInstance().setActive(true)
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            //guard let player = player else { return }
            
            player?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }*/
    
    // detects the touch and does the cat stuff accordingly
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (pauseInteraction) { return }
        
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
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
            self.pauseInteraction = true
            let wait = SKAction.wait(forDuration: GameScene.catInTreeTime)
            let hide = SKAction.hide()
            let sequence = SKAction.sequence([wait, hide])
            
            setupTrial(beginning: false)

            if (runSettings.catIsLeft[runNumber]) {
                leftCat?.isHidden = false
                leftCat?.run(sequence)
            }
            else {
                rightCat?.isHidden = false
                rightCat?.run(sequence)
            }
            
            // correct!
            if (pickedLeft && runSettings.catIsLeft[runNumber] || pickedRight && !runSettings.catIsLeft[runNumber]) {
                correctSound?.play()
            }
            else {  // incorrect D:
                incorrectSound?.play()
            }
            
            runNumber += 1
            if (runNumber == runSettings.catIsLeft.count) {
                gameDelegate?.launchViewController(scene: self)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //    for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    //    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    //    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
