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
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Binding the port selector to the content of the serialPortManager
        deviceList.bind(.content, to: serialPortManager, withKeyPath: "availablePorts", options: nil) // Works
        deviceList.bind(.contentValues, to: serialPortManager, withKeyPath: "availablePorts.name", options: nil)
    }

    // 
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

