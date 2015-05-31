//
//  OTMAnnotation.swift
//  On The Map
//
//  Created by Frédéric Lépy on 04/05/2015.
//  Copyright (c) 2015 Frédéric Lépy. All rights reserved.
//

import UIKit
import MapKit

class OTMAnnotation : NSObject, MKAnnotation {
    
    var coordinate : CLLocationCoordinate2D
    var title : String
    var subtitle : String
    
    
    init(position: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = position
        self.title = title
        self.subtitle = subtitle
    }
    
}
