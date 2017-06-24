////
////  LocationManager.swift
////  EliranFrog
////
////  Created by Matan on 24/06/2017.
////  Copyright © 2017 Eliran Levy. All rights reserved.
////
//
//import UIKit
//import CoreLocation
//
//class LocationManager: NSObject , CLLocationManagerDelegate{
//
//    
//    let locationManager = CLLocationManager()
//    var currentLocation: CLLocation!
//    
//   // locationManager.delegate
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    locationManager.requestWhenInUseAuthorization()
//    locationManager.startUpdatingLocation()
//    
//    @objc func initLocation() {
//        let status  = CLLocationManager.authorizationStatus()
//        
//        if status == .notDetermined {
//            locationManager.requestWhenInUseAuthorization()
//        }
//        
//        if status == .denied || status == .restricted {
//            //Makes sure user will be prompted again if returns to game without actually making changes
//            NotificationCenter.default.addObserver(
//                self,
//                selector: #selector(self.initLocation),
//                name: .UIApplicationWillEnterForeground,
//                object: nil)
//            
//            //Creates alert
//            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings, it's important!", preferredStyle: UIAlertControllerStyle.alert)
//            
//            //Dismiesses the game view
//            alert.addAction(UIAlertAction(title: "No!", style: .default, handler: { _ in self.dismiss(animated: true, completion: nil)}))
//            
//            //Deep link, works partially due to iOS 10 related changes
//            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
//                //For some reason this only works if the settings app is running in the background
//                let url = URL(string: UIApplicationOpenSettingsURLString)
//                let app = UIApplication.shared
//                app.open(url!, options: [:], completionHandler: nil)
//            }))
//            
//            present(alert, animated: true, completion: nil)
//        }
//        
//        if status == .authorizedWhenInUse {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.startUpdatingLocation()
//        }
//        
//    }
//    
//    
//    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        initLocation()
//    }
//    
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        currentLocation = locations[0]
//        print(currentLocation)
//    }
//
//    
//}
