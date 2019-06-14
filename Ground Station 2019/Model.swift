//
//  Model.swift
//  Ground Station 2019
//
//  Created by Stephen Flores on 3/29/19.
//  Copyright © 2019 Prograde. All rights reserved.
//

import Foundation


// ***** Control how data is defined and handled

// MARK: - Configuration variables
let telemHeader = "3623"
let alertHeader = "Alert"
let expectedTelemLength = 16 // number of comma-separated values

// MARK: - Handle all incoming bytes

// Parser: enable
class Parser {
    
    // Internal data
    private var tempString = ""
    private var stringQueue: [String] = []
    
    // Functions
    func ingest(char c: Character) {
        if (c == "\r\n") { // Both?
            stringQueue.append(tempString)
            tempString = ""
            return
        }
        if (c == "\r") {
//            print("Parser.ingest(): Lonely r! Appending.")
            stringQueue.append(tempString)
            tempString = ""
            return
        }
        if (c == "\n") {
//            print("Parser.ingest(): Lonely n!")
            return
        }
        
        tempString.append(c)
    }
    
    func hasPackets() -> Bool {
        return stringQueue.count > 0
    }
    
    func popNext() -> String {
        return stringQueue.remove(at: 0)
    }
}


// MARK: - Packet validation

func isTelem(_ packet: String) -> Bool {
    let fields = packet.split(separator: ",")
    
    if fields.count != expectedTelemLength {
        return false
    }
    
    if fields[0] != telemHeader {
        return false
    }
    
    return true
}

func isAlert(_ packet: String) -> Bool {
    let fields = packet.split(separator: ",")
    
    if fields.count != 2 {
        return false
    }
    
    if fields[0] != alertHeader {
        return false
    }
    
    return true
}


// MARK: - Telemetry definition
class TelemetryField {
    // Fields
    var value = 0.0
    var name = ""
    
    init(name: String) {
        self.name = name
    }
    
    func set(_ v: Double) {
        self.value = v
    }
}

class Telemetry {
    // 3623,60,40,1000,1013,20,3.3,123.5,33.5,-111.9,1410,3,0.01,0.0,9.4,3
    // <TEAM ID>,<MISSION TIME>,<PACKET COUNT>,<ALTITUDE>, <PRESSURE>, <TEMP>,<VOLTAGE>,<GPS TIME>,<GPS LATITUDE>,<GPS LONGITUDE>,<GPS ALTITUDE>,<GPS SATS>,<PITCH>,<ROLL>,<BLADE SPIN RATE>,<SOFTWARE STATE>,<BONUS DIRECTION>
    // Fields
    var fields: [TelemetryField] = []
    
    init() {
        // Create the 15 fields
        fields.append(TelemetryField(name: "met (s)")) // L
        fields.append(TelemetryField(name: "packetCount (int)")) // L
        fields.append(TelemetryField(name: "altitude (m)")) // G
        fields.append(TelemetryField(name: "pressure (Pa)")) // G
        fields.append(TelemetryField(name: "temperature (°C)")) // G
        
        fields.append(TelemetryField(name: "voltage (V)")) // G
        fields.append(TelemetryField(name: "gpsTime (s)")) // L
        fields.append(TelemetryField(name: "gpsLat (°)")) // L
        fields.append(TelemetryField(name: "gpsLon (°)")) // L
        fields.append(TelemetryField(name: "gpsAlt (m)")) // G
        
        fields.append(TelemetryField(name: "gpsSats (int)")) // L
        fields.append(TelemetryField(name: "pitch (°/s)")) // G
        fields.append(TelemetryField(name: "roll (°/s)")) // G
        fields.append(TelemetryField(name: "bladeSpinRate (rpm)")) // G
        fields.append(TelemetryField(name: "state (int)")) // L
    }
    
    // Field update logic
    func set(using packet: String) -> Bool {
        // Guarantee that it's valid
        if !isTelem(packet) {
            print("Cannot set telemetry using non-packet string: \(packet)")
            return false
        }
        
        var packetFields = packet.split(separator: ",")
        packetFields.removeFirst() // Don't care about team ID
        var errorCount = 0
        
        // Protect fields. Bad values are left alone? Or zero?
        for i in 0..<packetFields.count {
            if let value = Double(packetFields[i]) {
                self.fields[i].set(value)
            } else {
                errorCount += 1
                print("Unable to set \(self.fields[i].name) with value `\(packetFields[i])`")
            }
        }
        
        return errorCount == 0
    }
    
}
