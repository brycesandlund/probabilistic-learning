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
    var correct: [Bool?]
    // Reaction time in seconds. Populated similarly to "correct" array
    var RT: [Double?]
    
    // Initialize a RunResults object for a given number of runs
    init(runs: Int) {
        correct = Array(repeating: nil, count: runs)
        RT = Array(repeating: nil, count: runs)
    }
}
