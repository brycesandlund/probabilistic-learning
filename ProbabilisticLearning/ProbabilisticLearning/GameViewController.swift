//
//  GameViewController.swift
//  ProbabilisticLearning
//
//  Created by Bryce Sandlund on 3/28/18.
//  Copyright © 2018 Bryce Sandlund. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

protocol GameDelegate {
    func launchViewController()
}

class GameViewController: UIViewController, GameDelegate {
    
    func launchViewController() {
        self.performSegue(withIdentifier: "finish", sender: nil)
    }
    
    var runSettings : RunSettings!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Pass parameters of run into scene object
                scene.runSettings = self.runSettings
                scene.gameDelegate = self
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
        }
        
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    /*    if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }*/
        return .landscapeRight
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // only segue out of here is to the end. Time to store the data.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Attempting to write to file")
        runSettings.saveResults()
    }
}
