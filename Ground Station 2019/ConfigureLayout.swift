//
//  ConfigureLayout.swift
//  Ground Station 2019
//
//  Created by Stephen Flores on 6/13/19.
//  Copyright © 2019 Prograde. All rights reserved.
//

import Foundation
import Cocoa

// MARK: - Configure graph layout
extension ViewController {
    func configureGraphLayout() {
        // Add panel for graphs
        let graphPanel = Panel()
        self.view.addSubview(graphPanel)
        graphPanel.translatesAutoresizingMaskIntoConstraints = false
        graphPanel.leadingAnchor.constraint(equalTo: self.telemView.trailingAnchor, constant: 10).isActive = true
        graphPanel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        graphPanel.topAnchor.constraint(equalTo: self.telemView.topAnchor).isActive = true
        graphPanel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        
//        graphPanel.setColor(NSColor.white)
        graphPanel.autoresizesSubviews = true
        
        // Create graphs
        for i in 0..<9 {
            let graph = GraphView()
            graph.name = "Graph \(i)"
            self.graphs.append(graph)
        }
        
        // Add graphs to that panel
        // *****  Bahhhh! Use stackviews?
        
        // 1. Declare main stack, assign distribution properties, and add it to view hierarchy
        let rowStack = NSStackView(frame: graphPanel.frame)
        rowStack.distribution = .fillEqually
        rowStack.orientation = .vertical
        rowStack.autoresizesSubviews = true
        graphPanel.addSubview(rowStack)
        
        // 2. Declare your subviews, add them to the view hierarcy
        let row1 = NSStackView(views: [graphs[0], graphs[1], graphs[2]])
        let row2 = NSStackView(views: [graphs[3], graphs[4], graphs[5]])
        let row3 = NSStackView(views: [graphs[6], graphs[7], graphs[8]])
        
        rowStack.addView(row1, in: .top)
        rowStack.addView(row2, in: .top)
        rowStack.addView(row3, in: .top)
        
        // 3. Set AutoLayout constraints on the main stack
        rowStack.translatesAutoresizingMaskIntoConstraints = false
        rowStack.topAnchor.constraint(equalTo: graphPanel.topAnchor).isActive = true
        rowStack.bottomAnchor.constraint(equalTo: graphPanel.bottomAnchor).isActive = true
        rowStack.leadingAnchor.constraint(equalTo: graphPanel.leadingAnchor).isActive = true
        rowStack.trailingAnchor.constraint(equalTo: graphPanel.trailingAnchor).isActive = true
        
        // 4. Assign distribution properties of the subviews
        row1.distribution = .fillEqually
        row1.autoresizesSubviews = true
        
        row2.distribution = .fillEqually
        row2.autoresizesSubviews = true
        
        row3.distribution = .fillEqually
        row3.autoresizesSubviews = true
        
    }
    
    
    
    func configureFileWrite() {
        // Add filewrite button above the graph panel (just put at top of screen)
    }
}
