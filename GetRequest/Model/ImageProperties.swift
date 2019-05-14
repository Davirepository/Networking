//
//  ImageProperties.swift
//  GetRequest
//
//  Created by Давид on 14/05/2019.
//  Copyright © 2019 Давид. All rights reserved.
//

import UIKit

// структура для передачи изображения в кнопке "Upload Image"
struct ImageProperties {
    // на сервер нужно передать 2 параметра ключ(это слово "image" - его смотрим на сайте https://api.imgur.com/endpoints/image) и значение(само изображение)
    let key: String
    let data: Data
    
    // инициализатор проваливающийся так как извлечение картики может быть опциональным значением
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        guard let data = image.pngData() else { return nil } // конвертация формата типа png в данные
        self.data = data
    }
}
