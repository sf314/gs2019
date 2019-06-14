//
//  UpdateLabels.swift
//  Ground Station 2019
//
//  Created by Stephen Flores on 6/14/19.
//  Copyright © 2019 Prograde. All rights reserved.
//

import Foundation
import Cocoa


extension ViewController {
    func updateLabels(using telem: Telemetry) {
        metLabel.stringValue = "\(telem.fields[0].value)"
        packetLabel.stringValue = "\(telem.fields[1].value)"
        gpsTimeLabel.stringValue = "\(telem.fields[6].value)"
        gpsLatLabel.stringValue = "\(telem.fields[7].value)"
        gpsLonLabel.stringValue = "\(telem.fields[8].value)"
        gpsSatLabel.stringValue = "\(telem.fields[10].value)"
        stateLabel.stringValue = "\(telem.fields[14].value)"
    }
}
