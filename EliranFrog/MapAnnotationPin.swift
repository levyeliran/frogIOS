//
//  MapAnotationPin.swift
//  EliranFrog
//
//  Created by Matan on 17/06/2017.
//  Copyright © 2017 Eliran Levy. All rights reserved.
//

import Foundation
import MapKit

class MapAnnotationPin: NSObject , MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var myCoordinate: CLLocationCoordinate2D
   // var color: MKPinAnnotationView = MKPinAnnotationView.greenPinColor()
    
    var coordinate: CLLocationCoordinate2D {
        return myCoordinate
    }
    
     init(title: String , subtitle: String , myCoordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.myCoordinate = myCoordinate
    }
    
   
    
//    func changeColor(color: UIColor){
//        self.pinTintColor = color
//    }
    
}

//extension MapAnnotationPin {
//    static func bluePinColor() -> UIColor {
//        return UIColor.blue
//    }
//}
