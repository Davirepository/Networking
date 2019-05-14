//
//  WebsiteDescription.swift
//  GetRequest
//
//  Created by Давид on 13/05/2019.
//  Copyright © 2019 Давид. All rights reserved.
//

import Foundation

// вложенные данные
struct WebsiteDescription: Decodable {
    
    // не обязательно создавать все поля которые находятся в json
    // создаем поля опциональными на случай их отсутствия
    let websiteDescription: String?
    let websiteName: String?
    let courses: [Course] // данные course: { словари джейсон }
}
