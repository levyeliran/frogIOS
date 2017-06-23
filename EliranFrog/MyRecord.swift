//
//  Record.swift
//  EliranFrog
//
//  Created by Matan on 17/06/2017.
//  Copyright © 2017 Eliran Levy. All rights reserved.
//

import Foundation
import MapKit

class MyRecord: NSObject {
    var playerName: String?
    var score: Int?
    var coordinateOfRecord: CLLocationCoordinate2D
    
    init(playerName: String , score: Int ,coordinateOfRecord: CLLocationCoordinate2D ) {
        self.playerName = playerName
        self.score = score
        self.coordinateOfRecord = coordinateOfRecord
    }
    
    
    
    
}
