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

    // MARK: - Button Callbacks
    @IBAction func sendCommand(_ sender: Any) {
        
        // Get text from command field
        let command = commandField.stringValue
        
        // Update alert view
        let alertString = "Sending command \"\(command)\"\n"
        append(to: alertView, string: alertString)
        
        // TODO: - Send cmd over serial
        
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
    
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Binding the port selector to the content of the serialPortManager
        deviceList.bind(.content, to: serialPortManager, withKeyPath: "availablePorts", options: nil) // Works
        deviceList.bind(.contentValues, to: serialPortManager, withKeyPath: "availablePorts.name", options: nil)
        
        // Set user edit-ability
        (telemView.contentView.documentView as! NSTextView).isEditable = false
        (alertView.contentView.documentView as! NSTextView).isEditable = false
    }

    // 
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

