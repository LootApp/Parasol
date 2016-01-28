//
//  main.swift
//  Parasol
//
//  Created by Kyle McAlpine on 30/12/2015.
//  Copyright © 2015 Loot Financial Services Ltd. All rights reserved.
//

import Foundation

// TODO: make passing Xcode project as an optional argument
if let xcodeProject = XcodeProject.findXcodeProjectInCurrentDirectory() {
    let targets = xcodeProject.targets
    print("Which target in \(xcodeProject.name):")
    for i in 1...targets.count {
        print("\(i)) \(targets[i - 1].name)")
    }
    let input = readLine()
    if let input = input, index = Int(input) where index - 1 >= 0 && index <= targets.count  {
        let target = targets[index - 1]
        if case let .Exists(profdataPath, executablePath) = target.coverageDataExists {
            for line in Coverage.showCoverageReport(profdataPath, executablePath: executablePath).lines {
                print(line)
            }
        } else {
            print("Coverage data has not been generated. Would you like to run tests? (y/n)")
            let input = readLine()
            if input == "y" {
                target.runTests()
                if case let .Exists(profdataPath, executablePath) = target.coverageDataExists {
                    for line in Coverage.showCoverageReport(profdataPath, executablePath: executablePath).lines {
                        print(line)
                    }
                } else {
                    let errorMessage = "ERROR: Coverage data was not generated by Xcode."
                    NSFileHandle.fileHandleWithStandardError().writeData(errorMessage.dataUsingEncoding(NSUTF8StringEncoding)!)
                }
            } else if input == "n" {
                
            }
        }
    }
} else {
    let errorMessage = "Couldn't find an Xcode project"
    NSFileHandle.fileHandleWithStandardError().writeData(errorMessage.dataUsingEncoding(NSUTF8StringEncoding)!)
}

