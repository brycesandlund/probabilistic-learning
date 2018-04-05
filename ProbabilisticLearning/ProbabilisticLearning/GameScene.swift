//
//  GameScene.swift
//  ProbabilisticLearning
//
//  Created by Bryce Sandlund on 3/28/18.
//  Copyright © 2018 Bryce Sandlund. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    private var leftTree : SKSpriteNode?
    private var rightTree : SKSpriteNode?
    private var background : SKSpriteNode?
    private var leftCat : SKSpriteNode?
    private var rightCat : SKSpriteNode?
    
    // array to dictate location of cats during run.
    private var catIsLeft: [Bool] = [false, false, true, false, false, false, true, false, false, true]
    
    private var runNumber = 0
    
    override func didMove(to view: SKView) {
        
        self.leftTree = self.childNode(withName: "//leftTree") as? SKSpriteNode
        self.rightTree = self.childNode(withName: "//rightTree") as? SKSpriteNode
        self.background = self.childNode(withName: "//background") as? SKSpriteNode
        self.leftCat = self.childNode(withName: "//leftCat") as? SKSpriteNode
        self.rightCat = self.childNode(withName: "//rightCat") as? SKSpriteNode
        
        leftCat?.isHidden = true
        rightCat?.isHidden = true
        
        background?.size = self.frame.size  // not sure if this is doing anything
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
            let wait = SKAction.wait(forDuration: 2)
            let hide = SKAction.hide()
            let sequence = SKAction.sequence([wait, hide])
            
            if (catIsLeft[runNumber]) {
                leftCat?.isHidden = false
                leftCat?.run(sequence)
            }
            else {
                rightCat?.isHidden = false
                rightCat?.run(sequence)
            }
            
            runNumber += 1
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
