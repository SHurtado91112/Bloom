//
//  BloomAPI.swift
//  Bloom
//
//  Created by Steven Hurtado on 12/8/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit

class BloomAPI {
    static let sharedInstance = BloomAPI()

    func httpRequest(with url: URL, method: String, param: String, success: @escaping (Any) -> (), failure: @escaping (Error) -> ()) {
        print(url.absoluteString)
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if(method == "POST") {
            request.httpBody = param.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    // Convert the data to JSON
                    print(data)
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) //as? [String : Any]
                    if let json = jsonSerialized as? [String : Any] {
                        success(json)
                    }
                    else if let json = jsonSerialized as? Array<Any> {
                        success(json)
                    }
                }  catch {
                    failure(error)
                }
            } else if let error = error {
                failure(error)
            }
        }
        task.resume()
        return
    }
    
    func getFlowerData(success: @escaping (Any) -> (), failure: @escaping (Error) -> ()) {
        if let url = URL(string: "\(Secrets.apiBaseURL)/\(Flower.allFlowersEndPoint)") {
            httpRequest(with: url, method: "GET", param: "", success: { (data) in
                success(data)
            }, failure: { (error) in
                failure(error)
            })
        }
    }
    
    func getSightingData(flowerName: String, success: @escaping (Any) -> (), failure: @escaping (Error) -> ()) {
        guard let flowerName = flowerName.stringByAddingPercentEncodingForURLQueryValue() else{return}
        if let url = URL(string: "\(Secrets.apiBaseURL)/\(Sighting.oneFlowerEndPoint)\(flowerName)") {
            httpRequest(with: url, method: "GET", param: "", success: { (data) in
                success(data)
            }, failure: { (error) in
                failure(error)
            })
        }
    }
    
    func insertSightingData(flowerName: String, json: Dictionary<String, Any>, success: @escaping (Any) -> (), failure: @escaping (Error) -> ()) {
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json)
            if let param = String(data: data, encoding: .utf8) {
                if let url = URL(string: "\(Secrets.apiBaseURL)/\(Sighting.insertSightingEndPoint)") {
                    httpRequest(with: url, method: "POST", param: param, success: { (data) in
                        success(data)
                    }, failure: { (error) in
                        failure(error)
                    })
                }
            }
        } catch {
            print("Error parsing JSON.")
        }
        
    }
    
    func imageSearch(query: String?, success: @escaping (Any) -> (), failure: @escaping (Error) -> ()) {
        guard let query = query?.stringByAddingPercentEncodingForURLQueryValue() else{return}
        let stringURL = "\(Secrets.customSearchBaseURL)key=\(Secrets.googleAPIKey)&cx=\(Secrets.cx)&q=\(query)&searchType=image"
        
        if let url = URL(string: stringURL) {
            httpRequest(with: url, method: "GET", param: "", success: { (data) in
                success(data)
            }) { (error) in
                failure(error)
            }
        }
    }
    
    
}
