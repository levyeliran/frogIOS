//
//  RecordManager.swift
//  EliranFrog
//
//  Created by Matan on 17/06/2017.
//  Copyright © 2017 Eliran Levy. All rights reserved.
//

import Foundation
import MapKit

 class RecordManager  {
    
    var recordList : [Record] = []
    
    
    
    func addRecord(playerName: String, score: Int, coordinateOfRecord: CLLocationCoordinate2D){
       
        let record = Record(playerName: playerName , score: score , coordinateOfRecord: coordinateOfRecord)
        recordList.append(record)
        recordList.sort{
            $0.score! > $1.score!
        }
        
    }
    
    
    func getBestScore() -> Int{
        if recordList.count > 0 {
            return recordList[0].score!
        }
        else{
            return 0
        }
    }
    
    func getRecordPosition(score: Int) -> Int{
        return 1

    }
    
    func isNewRecord(score: Int) -> Bool {
        if score > recordList[0].score! {
            return true
        }
        else{
            return false
        }
    }
    
    
    
    
}















