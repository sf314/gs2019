//
//  UpdateGraphs.swift
//  Ground Station 2019
//
//  Created by Stephen Flores on 6/13/19.
//  Copyright © 2019 Prograde. All rights reserved.
//

import Foundation
import Cocoa


extension ViewController {
    
    
    func updateGraphs(using telem: Telemetry) {
        // Enforce number of graphs
        guard graphs.count >= 9 else {
            print("9 graphs required, found \(graphs.count)!")
            return
        }
        
        // Update graph data and labels: telem fields 2,3,4, 5,8,9, 10,11,12
        graphs[0].add(telem.fields[2].value); graphs[0].name = telem.fields[2].name
        graphs[1].add(telem.fields[3].value); graphs[1].name = telem.fields[3].name
        graphs[2].add(telem.fields[4].value); graphs[2].name = telem.fields[4].name
        
        graphs[3].add(telem.fields[5].value); graphs[3].name = telem.fields[5].name
        graphs[4].add(telem.fields[9].value); graphs[4].name = telem.fields[9].name
        graphs[5].add(telem.fields[10].value); graphs[5].name = telem.fields[10].name
        
        graphs[6].add(telem.fields[11].value); graphs[6].name = telem.fields[11].name
        graphs[7].add(telem.fields[12].value); graphs[7].name = telem.fields[12].name
        graphs[8].add(telem.fields[13].value); graphs[8].name = telem.fields[13].name
        
        for graph in graphs {
            graph.updateDisplay()
        }
        
    }
}
