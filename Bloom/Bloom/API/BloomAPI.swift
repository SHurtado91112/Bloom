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

    func httpRequest(with url: URL, method: String, success: @escaping (Dictionary<String, Any>) -> (), failure: @escaping (Error) -> ()) {
        print(url.absoluteString)
        var request = URLRequest(url: url)
        request.httpMethod = method
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    // Convert the data to JSON
                    print(data)
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    if let json = jsonSerialized {
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
    
    func getFlowerData(success: @escaping (Dictionary<String, Any>) -> (), failure: @escaping (Error) -> ()) {
        if let url = URL(string: Flower.modelEndPoint) {
            httpRequest(with: url, method: "GET", success: { (data) in
                success(data)
            }, failure: { (error) in
                failure(error)
            })
        }
    }
    
    
    
    func imageSearch(query: String?, success: @escaping (Dictionary<String, Any>) -> (), failure: @escaping (Error) -> ()) {
        guard let query = query?.stringByAddingPercentEncodingForURLQueryValue() else{return}
        let stringURL = "\(Secrets.customSearchBaseURL)key=\(Secrets.googleAPIKey)&cx=\(Secrets.cx)&q=\(query)&searchType=image"
        
        if let url = URL(string: stringURL) {
            httpRequest(with: url, method: "GET", success: { (data) in
                success(data)
            }) { (error) in
                failure(error)
            }
        }
    }
    
    
}
