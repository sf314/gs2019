//
//  Ground_Station_2019Tests.swift
//  Ground Station 2019Tests
//
//  Created by Stephen Flores on 3/29/19.
//  Copyright © 2019 Prograde. All rights reserved.
//

import XCTest
@testable import Ground_Station_2019

class Ground_Station_2019Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testParser() {
        let testString = "3623,60,40,1000,1013,20,3.3,123.5,33.5,-111.9,1410,3,0.01,0.0,9.4,1\r\n" +
        "3623,60,40,1000,1013,20,3.3,123.5,33.5,-111.9,1410,3,0.01,0.0,9.4,2\r\n" +
        "3623,60,40,1000,1013,20,3.3,123.5,33.5,-111.9,1410,3,0.01,0.0,9.4,3\r\n" +
        "Alert,Hey there1\r\n" +
        "3623,60,40,1000,1013,20,3.3,123.5,33.5,-111.9,1410,3,0.01,0.0,9.4,4\r\n" +
        "Alert,Hey there2\r\n" +
        "Alert,Hey there3\r\n" +
        
        "3623,60,40,1000,1013,20,,123.5,33.5,-111.9,1410,3,0.01,0.0,9.4,4\r\n" + /* This does not pass isTelem test */
        "Alert,This,is,invalid\r\n" /* This does not pass isAlert test */
        
        let parser = Parser()
        let telem = Telemetry()
        
        for c in testString {
            parser.ingest(char: c)
            
            if parser.hasPackets() {
                let newPacket = parser.popNext()
                print("Found packet: '\(newPacket)'")
                
                if isTelem(newPacket) {
                    print("  Packet is telemetry")
                    if telem.set(using: newPacket) {
                        print("  Telem was properly set using packet")
                    } else {
                        print("  ERR: Telem was not able to set all fields!")
                    }
                    continue
                }
                
                if isAlert(newPacket) {
                    print ("  Packet is alert")
                    continue
                }
                
                print("  ERR: Packet was malformed in some way!")
            }
        }
    }

}
