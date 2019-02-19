//
//  CommsProvider.swift
//  WeatherHub
//
//  Created by Siddharth Paneri on 18/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation
import Alamofire

class CommsProvider {
    private static var _sharedInstance: CommsProvider?
    class var sharedInstance : CommsProvider {
        guard let shared = _sharedInstance else {
            _sharedInstance = CommsProvider()
            return _sharedInstance!
        }
        return shared
    }
    
    
    /** Perform request  */
    func request(type: RequestType, params: [String: Any]?, _ completionHandler: @escaping (Any?, Error?)->()) {
        var url = BASE_URL
        if let param = params {
            if let metric = param["Metric"] as? String {
                if let location = param["Location"] as? String {
                    url.append("\(metric)-\(location).json")
                }
            }
        }
        print("CommsProvider.request: \(url)")
        Alamofire.request(url).responseJSON { (response) in
            if let result = response.result.value {
                print("CommsProvider: received response")
                completionHandler(result, nil)
            } else if let error = response.result.error {
                print("CommsProvider: Error- \(error)")
                completionHandler(nil, error)
            } else {
                print("CommsProvider: Error- nil")
                completionHandler(nil, nil)
            }
        }
    }
    
}
