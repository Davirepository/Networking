//
//  Course.swift
//  GetRequest
//
//  Created by Давид on 13/05/2019.
//  Copyright © 2019 Давид. All rights reserved.
//

import Foundation

struct Course: Decodable {
    
    // не обязательно создавать все поля которые находятся в json
    // создаем поля опциональными на случай их отсутствия
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    let numberOfLessons: Int?
    let numberOfTests: Int?
}
