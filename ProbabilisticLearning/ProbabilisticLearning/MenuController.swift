//
//  ViewController.swift
//  ProbabilisticLearning
//
//  Created by Bryce Sandlund on 5/2/18.
//  Copyright © 2018 Bryce Sandlund. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


class MenuController: UIViewController {
    
    @IBOutlet weak var buttonTest: UIButton!
    @IBOutlet weak var startDemo: UIButton!
    @IBOutlet weak var spreadStepper: UIStepper!
    @IBOutlet weak var LLabel: UILabel!
    @IBOutlet weak var RLabel: UILabel!
    @IBOutlet weak var trialCountStepper: UIStepper!
    @IBOutlet weak var trialCountLabel: UILabel!
    @IBOutlet weak var participantIDField: UITextField!
    @IBOutlet weak var genderToggle: UISegmentedControl!
    @IBOutlet weak var dateOfBirthPicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func trialCountChanged(_ sender: UIStepper) {
        let actualValue = Int(sender.value)
        trialCountLabel.text = String(actualValue)
    }
    
    @IBAction func spreadChanged(_ sender: UIStepper) {
        let actualValue = Int(sender.value)
        LLabel.text = String(actualValue)
        RLabel.text = String(100-actualValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let controller = segue.destination as? GameViewController {
            if (segue.identifier == "StartDemo") {
                controller.runSettings = RunSettings()
            }
            else if (segue.identifier == "StartTrial") {
                let leftSpread = Int(spreadStepper.value)
                let trials = Int(trialCountStepper.value)
                let isMale = genderToggle.isEnabledForSegment(at: 0)
                let participantID = participantIDField.text
                let dateOfBirth = dateOfBirthPicker.date
                controller.runSettings = RunSettings(leftSpread: leftSpread, trials: trials, isMale: isMale, participantID: participantID!, dateOfBirth: dateOfBirth)
            }
        }
    }
}
