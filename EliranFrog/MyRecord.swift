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
    //var coordinateOfRecord: CLLocationCoordinate2D
    var long : Double?
    var lat : Double?

    
    override init() {
        
    }
    
    init(playerName: String , score: Int ,long: Double ,lat: Double) {
        self.playerName = playerName
        self.score = score
        //self.coordinateOfRecord = coordinateOfRecord
        self.long = long
        self.lat = lat
    }
    
    
    
    
}
