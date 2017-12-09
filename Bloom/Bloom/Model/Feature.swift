//
//  Feature.swift
//  Bloom
//
//  Created by Steven Hurtado on 12/8/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import Foundation

class Feature : NSObject {
    //initialization
    var location : String?
    var classVar : String?
    var longitude : Double?
    var latitude : Double?
    var map : String?
    var elev : Double?
    
    init(dict: Dictionary<String, Any>) {
        location = dict["LOCATION"] as? String
        classVar = dict["CLASS"] as? String
        
        if let long = dict["LONGITUDE"] as? Double, let lat = dict["LATITUDE"] as? Double {
            longitude = long
            latitude = lat
        }
        
        map = dict ["MAP"] as? String
        
        if let elev = dict["ELEV"] as? Double {
            self.elev = elev
        }
    }
}
