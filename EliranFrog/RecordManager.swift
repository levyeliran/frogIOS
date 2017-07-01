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
    
    static let RECORD_TABLE_SIZE: Int = 10
    static var recordList : [MyRecord] = []
    //required.addRecordI
    
    init() {
       
    }
    
    static func loadData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            var i = 0
            if results.count > 0 {
                for res in results as! [NSManagedObject] {
                    let recordItem = MyRecord()
                    RecordManager.recordList.insert(recordItem, at: i)
                    if let username = res.value(forKey: "username") as? String{
                        recordItem.playerName = username
                    }
                    if let score = res.value(forKey: "score") as? Int{
                        recordItem.score = score

                    }
                    if let long = res.value(forKey: "long") as? Double{
                        recordItem.long = long

                    }
                    if let lat = res.value(forKey: "lat") as? Double{
                        recordItem.lat = lat
                    }
                    i += 1
                    
                }
                    RecordManager.recordList.sort{
                    $0.score! > $1.score!
                    }
                    RecordManager.recordList = Array(RecordManager.recordList.prefix(RECORD_TABLE_SIZE))
                }
            
        }catch{
            fatalError("could not load data from core data:  \(error)")
        }
        
    }
    
    static func saveData(myRecord: MyRecord){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let record = NSEntityDescription.insertNewObject(forEntityName: "Record", into: context)
        record.setValue(myRecord.playerName, forKey: "username")
        record.setValue(myRecord.score, forKey: "score")
        record.setValue(myRecord.long, forKey: "long")
        record.setValue(myRecord.lat, forKey: "lat")
        
        do {
            try context.save()
            //debug
            for x in RecordManager.recordList{
                print(x.playerName!)
                
            }
        }catch{
            fatalError("failed to save context: \(error)")
        }
    }
    
    static func addRecord(playerName: String, score: Int, long: Double ,lat: Double){
       
        let record = MyRecord(playerName: playerName , score: score , long: long ,lat: lat)
        if RecordManager.recordList.count >= RECORD_TABLE_SIZE {
            RecordManager.recordList.removeLast()
            print("The record list size is \(RECORD_TABLE_SIZE)")
        }
        RecordManager.recordList.append(record)
        RecordManager.recordList.sort{
            $0.score! > $1.score!
        }
        //deleteAllData(entity: "Record")
        self.saveData(myRecord: record)
    }
    
    
    static func getBestScore() -> Int{
         if(!recordList.isEmpty){
            return RecordManager.recordList[0].score!
        }
        else{
            return 0
        }
    }
    
    static func isNewRecord(score: Int) -> Bool {
        if(!recordList.isEmpty){
            if score > recordList[(recordList.count)-1].score! {
                return true
            }
            else {
                return false
            }
        }
        return true
    }
    
    
    // clean core data
    static func deleteAllData(entity: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
                print("data deleted")
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    
}















