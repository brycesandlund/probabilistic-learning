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
    var leftSpread: Int?

    var isMale: Bool?
    var participantID: String?
    var dateOfBirth: Date?
    
    var runResults: RunResults?
    
    static let summaryFile = "Summary.csv"
    
    func documentFileExists(fileName: String) -> Bool {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(fileName) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE")
                return true
            } else {
                print("FILE NOT AVAILABLE")
                return false
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
            return false
        }
    }
    
    func writeToFile(fileName: String, fileContent: String, append: Bool) {
        let dir = try? FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask, appropriateFor: nil, create: true)
        
        // If the directory was found, we write a file to it
        if let fileURL = dir?.appendingPathComponent(fileName) {
            var output = fileContent
            
            if (append) {
                //reading
                do {
                    output = try String(contentsOf: fileURL, encoding: .utf8) + fileContent
                }
                catch {/* error handling here */}
            }
            
            do {
                try output.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
            }
        }
    }
    
    func outputSummary() {
        var summaryOutput = ""
        let fileExists = documentFileExists(fileName: RunSettings.summaryFile)
        
        if (!fileExists) {
            let header = "ParticipantID,Gender,Date of Birth,Percent Correct,Percentage Left,Number of Trials,Time of Testing\n"
            summaryOutput += header
        }
        
        var nCorrect = 0
        for val in (runResults?.correct)! {
            if (val)! { nCorrect += 1 }
        }
        let correctP = (Double(nCorrect) / Double((runResults?.correct.count)!)) * 100
        let correctPStr = String(format: "%2.2lf", correctP)
        
        let BirthDateFormatter = DateFormatter()
        BirthDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        BirthDateFormatter.dateFormat = "yyyy-MM-dd"

        let dob = BirthDateFormatter.string(from: dateOfBirth!)
        
        let TrialTimeFormatter = DateFormatter()
        TrialTimeFormatter.locale = Locale(identifier: "en_US_POSIX")
        TrialTimeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let testTime = TrialTimeFormatter.string(from: Date())
        
        
        let gender = isMale! ? "male" : "female"
        
        summaryOutput += "\(participantID!),\(gender),\(dob),\(correctPStr),\(leftSpread!),\(catIsLeft.count),\(testTime)\n"
        
        writeToFile(fileName: RunSettings.summaryFile, fileContent: summaryOutput, append: fileExists)
    }
    
    func outputDetail() {
        var fileName = participantID! + ".csv"
        var attempt = 1
        
        while (documentFileExists(fileName: fileName)) {
            attempt += 1
            fileName = participantID! + "_" + String(attempt) + ".csv"
        }
        
        var dataContent = ""
        let header = "Run,Choice,Correct,RT\n"
        
        dataContent += header
        
        for index in 0..<catIsLeft.count {
            let choseLeft = catIsLeft[index] && (runResults?.correct)![index]! || !catIsLeft[index] && !(runResults?.correct)![index]!
            let choseLeftStr = choseLeft ? "L" : "R"
            let correct = (runResults?.correct)![index]! ? "Y" : "N"
            let RT = String(format: "%.2lf", (runResults?.RT)![index]!)
            dataContent += "\(index+1),\(choseLeftStr),\(correct),\(RT)\n"
        }
        
        writeToFile(fileName: fileName, fileContent: dataContent, append: false)
    }
    
    func saveResults() {
        if runResults != nil {
            outputSummary()
            outputDetail()
        }
    }
    
    // returns an array of 10 booleans, with leftSpread/100 of them true
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
        self.leftSpread = leftSpread
        
        catIsLeft = []
        // Sam wants this to be evenly split for every 10 trials... Though this encourages the strategy of "oh this one hasn't come about in awhile!"...
        for _ in 0..<trials/10 {
            catIsLeft += getTen(leftSpread: leftSpread)
        }
        
        runResults = RunResults(runs: trials)
    }
    
    init() {}
}

