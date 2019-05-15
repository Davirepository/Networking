//
//  AlmofireNetworkRequest.swift
//  GetRequest
//
//  Created by Давид on 14/05/2019.
//  Copyright © 2019 Давид. All rights reserved.
//

import Foundation
import Alamofire

class AlomofireNetworkRequest {
    
    
    static func sendRequest(url: String, completion: @escaping (_ courses: [Course])->()) {
        
        guard let url = URL(string: url) else { return }
        
        request(url, method: .get).validate().responseJSON { (response) in
            
            switch response.result {
                
            case .success(let value):
                var courses = Course.getArray(from: value)!
                completion(courses)
                
                print(courses)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func responseData(url: String) {
        
        request(url).responseData { (responseData) in
            
            switch responseData.result {
            case .success(let data):
                guard let string = String(data: data, encoding: .utf8) else { return }
                print(string)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func responseString(url: String) {
        request(url).responseString { (responseString) in
            
            switch responseString.result {
            case .success(let string):
                print(string)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // получаем данные в том виде котором они представлены на сайте
    static func response(url: String) {
        
        request(url).response { (response) in
            
            guard
                let data = response.data,
                let string = String(data: data, encoding: .utf8)
                else { return }
            print(string)
        }
    }
}






























