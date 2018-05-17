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

// This delegate allows SKScene to perform a segue programatically
protocol GameDelegate {
    func launchViewController()
}

class GameViewController: UIViewController, GameDelegate {
    @IBOutlet weak var backToStartButton: UIButton!
    @IBOutlet weak var hideButton: UIButton!
    
    // Launches "finish" segue, via push.
    func launchViewController() {
        self.performSegue(withIdentifier: "finish", sender: nil)
    }
    
    // Run settings, set by MenuController.swift. Passed to SKScene.
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
                scene.backToStartButton = backToStartButton
                scene.hideButton = hideButton
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
        }
        
    }
    
    @IBAction func hideButtonClicked(_ sender: UIButton) {
        backToStartButton.isHidden = true
        hideButton.isHidden = true
    }
    
    // The following three functions were at one point used to force orientation, however there is another
    // setting in info.plist that may have actually done the trick
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // only segue out of here is to the end. Time to store the data.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        runSettings.saveResults()
    }
}
