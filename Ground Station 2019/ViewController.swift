//
//  ViewController.swift
//  Ground Station 2019
//
//  Created by Stephen Flores on 3/29/19.
//  Copyright © 2019 Prograde. All rights reserved.
//

import Cocoa
import Foundation

class ViewController: NSViewController, ORSSerialPortDelegate {
    
    
    // MARK: - Model
    let parser = Parser()
    var telemetry = Telemetry()
    
    // MARK: - Serial Model
    let serialPortManager = ORSSerialPortManager.shared()
    var port: ORSSerialPort? {
        didSet { // Is this necessary?
            oldValue?.close()
            oldValue?.delegate = nil
            port?.delegate = nil
            print("Port: didSet")
            print("Port: name is \(port?.path ?? "NONE SET")")
        }
    }
    
    // MARK: - UI Elements
    @IBOutlet weak var deviceList: NSPopUpButton!
    @IBOutlet weak var telemView: NSScrollView!
    @IBOutlet weak var alertView: NSScrollView!
    @IBOutlet weak var commandField: NSTextField!
    @IBOutlet weak var connectButton: NSButton!
    @IBOutlet weak var fileWriteButton: NSButton!
    
    
    var graphs: [GraphView] = []
    

    // MARK: - Button Callbacks
    @IBAction func sendCommand(_ sender: Any) {
        
        // Get text from command field
        let command = commandField.stringValue
        
        // Update alert view
        let alertString = "Sending command \"\(command)\""
        
        // TODO: - Send cmd over serial
        guard let data = command.data(using: String.Encoding.utf8) else {
            append(to: alertView, string: "Failed: bad data")
            return
        }
        
        guard let port = self.port else {
            append(to: alertView, string: "Failed: bad port")
            return
        }
        
        port.send(data)
        append(to: alertView, string: "\(alertString)\n")
    }
    
    @IBAction func toggleFileWrite(_ sender: Any) {
        if enableFileWrite {
            fileWriteButton.title = "FileWrite: off"
        } else {
            fileWriteButton.title = "FileWrite: on"
        }
        
        enableFileWrite = !enableFileWrite
    }
    
    
    
    // MARK: - Convenience
    
    func append(to view: NSScrollView, string: String) {
        // Add string to end of document
        (view.contentView.documentView as! NSTextView).textStorage?.append(NSAttributedString(string: string))
        (view.contentView.documentView as! NSTextView).scrollToEndOfDocument(nil)
        
        // Set colour AFTERWARDS
        // NOTE: text colour set applies only once, and works on all EXISTING text in the field, not stuff added afterwards
        (view.contentView.documentView as! NSTextView).textColor = .white
    }
    
    // MARK: - Parse incoming bytes
    func parseIncomingBytes(_ s: String) {
        for c in s {
            parser.ingest(char: c)
            
            if parser.hasPackets() {
                let newPacket = parser.popNext()
                
                if isTelem(newPacket) {
//                    print("  Packet is telemetry")
                    if telemetry.set(using: newPacket) {
//                        print("  Telem was properly set using packet")
                        append(to: telemView, string: "\(newPacket)\n")
                        write("\(newPacket)\n", toFile: telemetryFile)
                        updateGraphs(using: telemetry)
                    } else {
                        print("  ERR: Telem was not able to set all fields!")
                    }
                    continue
                }
                
//                print("Not telem: '\(newPacket)'")
                
                if isAlert(newPacket) {
                    append(to: alertView, string: "\(newPacket)\n")
//                    print ("  Packet is alert")
                    write("\(newPacket)\n", toFile: logFile)
                    continue
                }
                
                print("  ERR: Packet was malformed in some way: \"\(newPacket)\"")
                write("Malformed: \(newPacket)", toFile: logFile)
            }
        }
    }
    
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        initTelemDir()

        // Do any additional setup after loading the view.
        
        // Binding the port selector to the content of the serialPortManager
        deviceList.bind(.content, to: serialPortManager, withKeyPath: "availablePorts", options: nil) // Works
        deviceList.bind(.contentValues, to: serialPortManager, withKeyPath: "availablePorts.name", options: nil)
        
        // Set user edit-ability
        (telemView.contentView.documentView as! NSTextView).isEditable = false
        (alertView.contentView.documentView as! NSTextView).isEditable = false
        
        // Initialize graphs?
        configureGraphLayout()
        updateGraphs(using: telemetry)
    }

    // 
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

