//
//  Sighting.swift
//  Bloom
//
//  Created by Steven Hurtado on 12/8/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import Foundation

class Sighting : NSObject {
    //initialization
    var person : String?
    var location : String?
    var sighted : String?
    
    static let oneFlowerEndPoint = "getOneFlower/" //{flowerName}"
    static let updateSightingEndPoint = "updateFlower/" //{flowerName}
    static let insertSightingEndPoint = "insertFlower"
    
    init(dict: Dictionary<String, Any>) {
//        name = dict["NAME"] as? String
        person = dict["PERSON"] as? String
        location = dict ["LOCATION"] as? String
        sighted = dict ["SIGHTED"] as? String
    }
}

