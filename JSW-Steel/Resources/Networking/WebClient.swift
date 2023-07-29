//
//  WebClient.swift
//  TestApp
//
//  Created by Arokia IT on 8/5/20.
//  Copyright © 2020 Arokiait Pvt Ltd. All rights reserved.
//

import UIKit

final class WebClient {
    private var baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func load(path: String, method: RequestMethod, params: JSON, completion: @escaping (Any?, ServiceError?) -> ()) -> URLSessionDataTask? {
        // Checking internet connection availability
        if !MyCommonFunctionalUtilities.isInternetCallTheApi() {
            completion(nil, ServiceError.noInternetConnection)
            return nil
        }

        let request = URLRequest(baseUrl: baseUrl, path: path, method: method, params: params)

        // Sending request to the server.
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Parsing incoming data
            var object: Any? = nil
            if let data = data {
                object = data
            }
            if let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode {
                print(httpResponse.statusCode,"status code")
                
                completion(object, nil)
            } else {
                if let httpResponse = response as? HTTPURLResponse, 401 == httpResponse.statusCode{
                    print(httpResponse.statusCode,"status code")
                }else{
                    let error = (object as? JSON).flatMap(ServiceError.init) ?? ServiceError.other
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
        
        return task
    }
}
