//
//  Panel.swift
//  Ground Station 2019
//
//  Created by Stephen Flores on 6/13/19.
//  Copyright © 2019 Prograde. All rights reserved.
//

import Foundation
import Cocoa


class Panel: NSView {
    
    var backgroundColour = NSColor(calibratedRed: 28/255, green: 28/255, blue: 34/255, alpha: 1)
    
    func setColor(_ color: NSColor) {
        backgroundColour = color
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        // Generate rectangle that fills frame
        //let backgroundColour = NSColor(calibratedRed: 28/255, green: 28/255, blue: 34/255, alpha: 1)
//        backgroundColour.set()
////        bounds.fill() // Not NSRectFill(bounds) anymore!
    }
}
