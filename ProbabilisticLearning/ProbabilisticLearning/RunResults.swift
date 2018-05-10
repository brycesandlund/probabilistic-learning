//
//  RunResults.swift
//  ProbabilisticLearning
//
//  Created by Bryce Sandlund on 5/10/18.
//  Copyright © 2018 Bryce Sandlund. All rights reserved.
//

import Foundation

class RunResults {
    var correct: [Bool?]
    var RT: [Double?]
    
    init(runs: Int) {
        correct = Array(repeating: nil, count: runs)
        RT = Array(repeating: nil, count: runs)
    }
}
