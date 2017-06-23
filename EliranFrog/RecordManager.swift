//
//  RecordManager.swift
//  EliranFrog
//
//  Created by Matan on 17/06/2017.
//  Copyright © 2017 Eliran Levy. All rights reserved.
//

import Foundation
import MapKit
import CoreData
 class RecordManager  {
    
    
var recordList : [MyRecord] = []
    //required.addRecordI
    
    
    init() {
        
    }
    
    
    func saveData(){
        var long: Double = 32.113510
        var lat :Double  = 32.113510
//        var myCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 32.113510, longitude: 32.113510)

        
//        let moc = DataController(completionClosure: <#() -> ()#>).managedObjectContext
//        let record = NSEntityDescription.insertNewObject(forEntityName: "Record", into: moc)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let record = NSEntityDescription.insertNewObject(forEntityName: "Record", into: context)
        
        record.setValue("eliran", forKey: "username")
        record.setValue(20, forKey: "score")
        //record.setValue(myCoordinate, forKey: "location")
        
    
        
        do {
            try context.save()
            print(record)
        }catch{
            fatalError("failed to save context: \(error)")
        }
    }
    
    
    func addRecord(playerName: String, score: Int, coordinateOfRecord: CLLocationCoordinate2D){
       
        let record = MyRecord(playerName: playerName , score: score , coordinateOfRecord: coordinateOfRecord)
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















