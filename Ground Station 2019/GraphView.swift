//
//  GraphView.swift
//  Ground Station 2019
//
//  Created by Stephen Flores on 6/9/19.
//  Copyright © 2019 Prograde. All rights reserved.
//

import Foundation
import Cocoa


class GraphView: NSView {
//class GraphView: NSCollectionViewItem {

    // MARK: - Data variables and manipulation
    var data: [Double] = []
    
    var min = 0.0
    var max = 1.0
    var height = 0.0
    var width = 0.0
    var size = 200 // variable length?
    var debugMode = false
    var name = "Graph"
    var unit = ""
//    var type = GraphType.none
    
    let label = NSTextView()
//    let colors = CustomColorLibrary()
    let backgroundColour = NSColor(calibratedRed: 28/255, green: 28/255, blue: 34/255, alpha: 1)
    
    func add(_ point: Double) {
        var newPoint = point
        if newPoint < 0 {
            newPoint = 0 - newPoint
        }
        data.append(newPoint)
        if data.count > size { // size controlled
            data.remove(at: 0)
        }
        if point > max { // Track max
            max = point
        }
    }
    
    // MARK: - Drawing
    override func draw(_ rect: NSRect) {
        if label.string == "" {
            self.addSubview(label)
            self.autoresizesSubviews = true
        }

        if data.count == 0 {self.add(0.0)}
        super.draw(rect)

        // Draw background colour
//        backgroundMed.set()
//        NSColor.black.set()
        backgroundColour.set()
        bounds.fill()

        // Draw points (remember coordinate system!)
        // TODO: - Points up to max should appear starting from the right side (fixed width?)
        // Solution: Init array with \(size) points
        height = Double(self.frame.height) - 44.0 // Keep clear of label area
        width = Double(self.frame.width)
        let dx = width / Double(data.count) // Identify spacing width (dx) between points

        var x = 0.0
        for val in data {
            let rec = NSRect(x: x, y: map(val), width: 3, height: 3)
            let bez = NSBezierPath(roundedRect: rec, xRadius: 1.5, yRadius: 1.5)
//            colors.green.oldeGS.set()
            NSColor.green.set()
            bez.fill()
            x += dx
        }

        // Draw label: name of field, and latest data point on top!
        label.isEditable = false
        if let latestPoint = data.last {
            label.string = name + ": " + String(latestPoint) + unit
        } else {
            label.string = name
        }
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.widthAnchor.constraint(equalToConstant: 120).isActive = true
        label.heightAnchor.constraint(equalToConstant: 17).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        label.backgroundColor = backgroundLight
        
    }
    
    func map(_ y: Double) -> Double {
        // Map double value y to within the bounds of the rect (flipped: the right way round)
        return (height * y / max)
    }
    
    
    func updateDisplay() {
        self.setNeedsDisplay(self.bounds)
    }
    
    func set(name: String, unit: String) {
        self.name = name
        self.unit = unit
    }
    
    // MARK: - Debugging
    func debug(_ s: String) {
        if debugMode {
            print(s)
        }
    }
    
    func generateTestPoints() {
        for i in 1..<20 {
            self.add(Double(i));
        }
        for i in 1..<20 {
            self.add(Double(i));
        }
        for i in 1..<20 {
            self.add(Double(i));
        }
        add(12)
        add(12)
        add(12)
        add(12)
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("GraphView loaded")
//    }
    
}
