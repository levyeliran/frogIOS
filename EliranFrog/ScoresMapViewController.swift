//
//  ScoresMapViewController.swift
//  EliranFrog
//
//  Created by Matan on 17/06/2017.
//  Copyright © 2017 Eliran Levy. All rights reserved.
//

import UIKit
import MapKit

class ScoresMapViewController: UIViewController {

    //var recordM = RecordManager()
    @IBOutlet weak var mapView: MKMapView!
     var afekaLat: CLLocationDegrees = 32.113510
     var afekaLong: CLLocationDegrees =  34.818186
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareMap()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func prepareMap(){
        let distanceSpan: CLLocationDegrees = 1000000
        let afekaCampusLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(afekaLat, afekaLong)
        
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(afekaCampusLocation, distanceSpan, distanceSpan) , animated: true)
        
       
        for record in RecordManager.recordList{
            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(record.lat!, record.long!)
            let score : String
            score = "Score - " + ((record.score)?.description)!

            let recordMapPin = MapAnnotationPin(title: record.playerName!, subtitle: score, myCoordinate: location)
            mapView.addAnnotation(recordMapPin)
            print("record added to map: " )
        }
        
        let mapPin = MapAnnotationPin(title: "Afeka", subtitle: "top score", myCoordinate: afekaCampusLocation)
        
        mapView.addAnnotation(mapPin)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
