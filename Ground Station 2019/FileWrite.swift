//
//  FileWrite.swift
//  Ground Station 2019
//
//  Created by Stephen Flores on 6/13/19.
//  Copyright © 2019 Prograde. All rights reserved.
//

import Foundation


/* File Write
 Enable functionality to write strings to a file on the desktop
 Automatically apply newlines? Idk
 Support customizable filenames
 Toggle file write with boolean flag
 */

let debugMode = false

let telemDir = "CanSat_Telem " + dateToString(Date.init(timeIntervalSinceNow: 0))
let telemetryFile = "telemetry.csv"
let logFile = "log.txt"
var enableFileWrite = false

func write(_ s: String, toFile fileName: String) {
    if enableFileWrite {
        
        // Save to the desktop
        let fileURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first?.appendingPathComponent(telemDir + "/" + fileName)
        
        // If it doesn't exist, create it!
        if !FileManager.default.fileExists(atPath: (fileURL?.path)!) { //
            print("File did not exist at location \((fileURL?.path)!). Must create file.")
            do {
                try s.write(to: fileURL!, atomically: false, encoding: .utf8)
            } catch {
                print("Could not create file!")
            }
            
            return
        }
        
        // If it does exist, append to it!
        if let oStream = OutputStream(url: fileURL!, append: true) { // This works for files that already exist
            oStream.open()
            let length = s.lengthOfBytes(using: String.Encoding.utf8)
            oStream.write(s, maxLength: length) // Yes!!!!
            oStream.close()
        } else {
            print("Could not write to file!")
        }
    } else {
        print("FileWrite disabled")
    }
}


func initTelemDir() {
    if debugMode {
        return
    }
    
    let url = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0].appendingPathComponent(telemDir)
    do {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
    } catch {
        print("Could not create telemetry directory!!")
    }
}

let months = [
    "January": 1,
    "Feburary": 2,
    "March": 3,
    "April": 4,
    "May": 5,
    "June": 6,
    "July": 7,
    "August": 8,
    "September": 9,
    "October": 10,
    "November": 11,
    "December": 12
]

func dateToString(_ d: Date) -> String{
    var s = d.description(with: Locale.current)
    
    s = s.replacingOccurrences(of: ",", with: "") // Remove commas
    let substrings = s.split(separator: " ") // Split by spaces
    
    let month = String(months[String(substrings[1])]!)
    let day = String(substrings[2])
    let year = String(substrings[3])
    let time = String(substrings[5]) + String(substrings[6])
    
    var dateThing = year + "-"
    dateThing += month + "-"
    dateThing += day + "-"
    dateThing += time
    return dateThing.replacingOccurrences(of: ":", with: ".") // ":" not allowed in paths
}
