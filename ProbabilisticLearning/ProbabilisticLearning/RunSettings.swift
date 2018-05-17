//
//  RunSettings.swift
//  ProbabilisticLearning
//
//  Created by Bryce Sandlund on 5/9/18.
//  Copyright © 2018 Bryce Sandlund. All rights reserved.
//

import Foundation

class RunSettings {
    // this is set at initialization and read by GameScene to determine cat placement
    var catIsLeft: [Bool] = [true, true, false, false]
    
    func saveResults() {
        print("Demo run. Results ignored.")
    }
    
    // possibly record the trial, if not a demo
    func recordTrial(correct: Bool, RT: Double) {
        // do nothing
    }
    
    init() {}
}

