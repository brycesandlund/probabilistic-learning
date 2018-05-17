//
//  RunResults.swift
//  ProbabilisticLearning
//
//  Created by Bryce Sandlund on 5/10/18.
//  Copyright © 2018 Bryce Sandlund. All rights reserved.
//

import Foundation

class RunResults {
    // Stores whether choice is correct. Goes from nil to true or false as trial is executed
    var correct: [Bool] = []
    // Reaction time in seconds. Populated similarly to "correct" array
    var RT: [Double] = []
    
    func recordTrial(correct: Bool, RT: Double) {
        self.correct.append(correct)
        self.RT.append(RT)
    }
    
    init() {}
}
