//
//  Flower.swift
//  Bloom
//
//  Created by Steven Hurtado on 12/8/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import Foundation

class Flower : NSObject {
    //initialization
    var genus : String?
    var species : String?
    var comName : String?
    var sightings : [Sighting]?
    
    static let allFlowersEndPoint = "getAllFlowers"
    
    init(dict: Dictionary<String, Any>) {
        print(dict)
        genus = dict["GENUS"] as? String
        species = dict["SPECIES"] as? String
        comName = dict ["COMNAME"] as? String
        print("\(genus)\n\(species)\n\(comName)")
    }
}
