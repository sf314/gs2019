//
//  SerialEvents.swift
//  Ground Station 2019
//
//  Created by Stephen Flores on 5/12/19.
//  Copyright © 2019 Prograde. All rights reserved.
//

import Foundation
import Cocoa


// Handle events related to the serial bus and ORSSerialPort

extension ViewController {
    
    // Handle unplugging of a device
    func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
        print("Serial port was removed")
    }
    
    // Receive data at port
    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
        if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            let s = string as String
//            print("Received: \(s)") // 16 characters at a time, MS \r\n ending
//            addToSerialMonitor(s) // Handles parsing
//            telemView.textStorage?.mutableString.append("\(s)")
//            (telemView.contentView.documentView as! NSTextView).textStorage?.mutableString.append("\(s)")
            parseIncomingBytes(s)
        } else {
            print("Bad data at port.")
        }
    }
    
    // Handle error detect
    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        print("SerialPort \(serialPort) encountered an error: \(error)")
    }
    
    // Notify open and close
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        print("Serial port was opened")
//        connectButton.title = "Disconnect"
    }
    func serialPortWasClosed(_ serialPort: ORSSerialPort) {
        print("Serial port was closed")
//        connectButton.title = "Connect"
    }
    
    // Open or close the port
    @IBAction func connect(_ sender: Any) { // Use @Objc or @IBAction
        updateGraphs(using: telemetry)
        
        // Check state of port for safety!!!
        if self.port == nil {
            let stringPath = "/dev/cu." + deviceList.selectedItem!.title // HOLY COW FULL PATH
            print("connectButton: stringPath = \(stringPath)")
            port = ORSSerialPort(path: stringPath)
        }
        if let port = self.port {
            if port.isOpen {
                port.close() // Never run?
                print("connectButton: Closed port")
                self.connectButton.title = "Connect"
            } else {
                port.open() // If error, need USB access entitlement (for sandbox)
                port.delegate = self // BLOODY HELL
                port.baudRate = 9600
                print("connectButton: Opened port. Is it really open? \(port.isOpen)")
                if port.isOpen {
                    self.connectButton.title = "Disconnect"
                }
            }
        } else {
            print("connectButton: Port was null.")
            self.connectButton.title = "Connect"
        }
        print("connect: Current port baud is: \(String(describing: port?.baudRate))")
        print("connect: Selected item is: \(String(describing: deviceList.selectedItem?.title))")
    }
}
