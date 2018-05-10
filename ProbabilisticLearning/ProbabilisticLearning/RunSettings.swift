//
//  RunSettings.swift
//  ProbabilisticLearning
//
//  Created by Bryce Sandlund on 5/9/18.
//  Copyright © 2018 Bryce Sandlund. All rights reserved.
//

import Foundation
import GameplayKit

class RunSettings {
    var catIsLeft: [Bool] = [true, true, false, false]
    var record: Bool = false
    
    var isMale: Bool?
    var participantID: String?
    var dateOfBirth: Date?
    
    func getTen(leftSpread: Int) -> [Bool] {
        let array1: [Bool] = Array(repeating: true, count: leftSpread/10)
        let array2: [Bool] = Array(repeating: false, count: 10-(leftSpread/10))
        
        return GKRandomSource.sharedRandom().arrayByShufflingObjects(in: array1 + array2) as! [Bool]
    }
    
    // initiates a RunSetting, given probability and trials
    init(leftSpread: Int, trials: Int, isMale: Bool, participantID: String, dateOfBirth: Date) {
        self.isMale = isMale
        self.participantID = participantID
        self.dateOfBirth = dateOfBirth
        
        catIsLeft = []
        for index in 0..<trials/10 {
            catIsLeft += getTen(leftSpread: leftSpread)
        }
    }
    
    init() {}
}

