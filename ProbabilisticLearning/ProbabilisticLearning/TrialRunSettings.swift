//
//  TrialRunSettings.swift
//  ProbabilisticLearning
//
//  Created by Bryce Sandlund on 5/17/18.
//  Copyright © 2018 Bryce Sandlund. All rights reserved.
//

import GameplayKit
import Foundation

class TrialRunSettings : RunSettings {
    // determines how many out of each 10 trial increment are left, stored as an integer percentage
    var leftSpread: Int
    var isMale: Bool
    var participantID: String
    var dateOfBirth: Date
    
    var runResults = RunResults()
    
    // File to write summary results to
    static let summaryFile = "Summary.csv"
    
    // Checks if file fileName exists in documents directory
    func documentFileExists(fileName: String) -> Bool {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(fileName) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE at: \(filePath)")
                return true
            } else {
                print("FILE NOT AVAILABLE at \(filePath)")
                return false
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
            return false
        }
    }
    
    // Writes to file fileName in documents of App, the content fileContent, optionally appending if the file exists
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
    
    // outputs a summary to summary file
    func outputSummary() {
        var summaryOutput = ""
        let fileExists = documentFileExists(fileName: TrialRunSettings.summaryFile)
        
        if (!fileExists) {
            let header = "ParticipantID,Gender,Date of Birth,Percent Correct,Percentage Left,Number of Trials,Time of Testing\n"
            summaryOutput += header
        }
        
        var nCorrect = 0
        for val in (runResults.correct) {
            if (val) { nCorrect += 1 }
        }
        let correctP = (Double(nCorrect) / Double((runResults.correct.count))) * 100
        let correctPStr = String(format: "%2.2lf", correctP)
        
        let BirthDateFormatter = DateFormatter()
        BirthDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        BirthDateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dob = BirthDateFormatter.string(from: dateOfBirth)
        
        let TrialTimeFormatter = DateFormatter()
        TrialTimeFormatter.locale = Locale(identifier: "en_US_POSIX")
        TrialTimeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let testTime = TrialTimeFormatter.string(from: Date())
        
        
        let gender = isMale ? "male" : "female"
        
        summaryOutput += "\(participantID),\(gender),\(dob),\(correctPStr),\(leftSpread),\(runResults.correct.count),\(testTime)\n"
        
        writeToFile(fileName: TrialRunSettings.summaryFile, fileContent: summaryOutput, append: fileExists)
    }
    
    // outputs a detailed view per participant, appending _2, _3, ... if not first run with participant
    func outputDetail() {
        var fileName = participantID + ".csv"
        var attempt = 1
        
        while (documentFileExists(fileName: fileName)) {
            attempt += 1
            fileName = participantID + "_" + String(attempt) + ".csv"
        }
        
        var dataContent = ""
        let header = "Run,Choice,Cat,Correct,RT\n"
        
        dataContent += header
        
        for index in 0..<runResults.correct.count {
            let choseLeft = catIsLeft[index] && (runResults.correct)[index] || !catIsLeft[index] && !(runResults.correct)[index]
            let cat = catIsLeft[index] ? "L" : "R"
            let choseLeftStr = choseLeft ? "L" : "R"
            let correct = (runResults.correct)[index] ? "Y" : "N"
            let RT = String(format: "%.4lf", (runResults.RT)[index])
            dataContent += "\(index+1),\(choseLeftStr),\(cat),\(correct),\(RT)\n"
        }
        
        writeToFile(fileName: fileName, fileContent: dataContent, append: false)
    }
    
    // save both summary and detail results
    override func saveResults() {
        print("Saving Results")
        outputSummary()
        outputDetail()
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
        
        super.init()
        
        catIsLeft = []
        // Sam wants this to be evenly split for every 10 trials... Though this makes runs not independent of previous trials
        for _ in 0..<trials/10 {
            catIsLeft += getTen(leftSpread: leftSpread)
        }
    }
    
    // pass to runResults to record the trial
    override func recordTrial(correct: Bool, RT: Double) {
        runResults.recordTrial(correct: correct, RT: RT)
    }
}
