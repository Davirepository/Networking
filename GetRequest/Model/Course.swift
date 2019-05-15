//
//  Course.swift
//  GetRequest
//
//  Created by Давид on 13/05/2019.
//  Copyright © 2019 Давид. All rights reserved.
//

import Foundation

// Данная структура подходит для работы с URLSession
//struct Course: Decodable {
//
//    // не обязательно создавать все поля которые находятся в json
//    // создаем поля опциональными на случай их отсутствия
//    let id: Int?
//    let name: String?
//    let link: String?
//    let imageUrl: String?
//    let numberOfLessons: Int?
//    let numberOfTests: Int?
//}

struct Course: Decodable {
    
    // не обязательно создавать все поля которые находятся в json
    // создаем поля опциональными на случай их отсутствия
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    let numberOfLessons: Int?
    let numberOfTests: Int?
    
    init?(json: [String: Any]) {
        let id = json["id"] as? Int
        let name = json["name"] as? String
        let link = json["link"] as? String
        let imageUrl = json["imageUrl"] as? String
        let numberOfLessons = json["number_of_lessons"] as? Int
        let numberOfTests = json["number_of_tests"] as? Int
        
        self.id = id
        self.name = name
        self.link = link
        self.imageUrl = imageUrl
        self.numberOfLessons = numberOfLessons
        self.numberOfTests = numberOfTests
        
    }
    // обработка массива
    static func getArray(from jsonArray: Any) -> [Course]? {
        
        guard let jsonArray = jsonArray as? Array<[String: Any]> else { return nil }
        
//        var courses: [Course] = []
//
//        for jsonObject in jsonArray {
//
//            if let course = Course(json: jsonObject) {
//                courses.append(course)
//            }
//        }
//        return courses
        // код в 1 строчку (возврат массива словарей с типом Course)
        return jsonArray.compactMap { Course(json: $0)}
        
    }
}
































