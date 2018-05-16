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

// Used for beginning menu
class MenuController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var startTrial: UIButton!
    @IBOutlet weak var startDemo: UIButton!
    
    // spread UIStepper. Takes from 0-100 in steps of 10. Holds left value
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
        participantIDField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func trialCountChanged(_ sender: UIStepper) {
        let actualValue = Int(sender.value)
        trialCountLabel.text = String(actualValue)
    }
    
    // Update labels for Spread-thing.
    @IBAction func spreadChanged(_ sender: UIStepper) {
        let actualValue = Int(sender.value)
        LLabel.text = String(actualValue)
        RLabel.text = String(100-actualValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // Doesn't do anything (yet) but necessary so unwind in 3rd controller points back here
    @IBAction func unwindHere(unwindSegue: UIStoryboardSegue) {
        
    }
    
    // Uses the segue label to pass the appropriate data based on if a demo or a trial
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let controller = segue.destination as? GameViewController {
            if (segue.identifier == "startDemo") {
                controller.runSettings = RunSettings()
            }
            else if (segue.identifier == "startTrial") {
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
