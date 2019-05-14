//
//  NetworkManager.swift
//  GetRequest
//
//  Created by Давид on 13/05/2019.
//  Copyright © 2019 Давид. All rights reserved.
//

import UIKit

class NetworkManager {
    
    // получаем данные и ответ отсервера
    static func getRequest(url: String) {
        
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared
        // Создает задачу, которая извлекает содержимое указанного URL-адреса,а затем вызывает обработчик по завершении.
        session.dataTask(with: url) { (data, response, error) in
            
            guard
                let response = response, // получаем ответ от сервера
                let data = data
                else { return }
            print(response)
            print(data)
            
            // делаем сериализацию перевод данных из одного типа в другой без потери данных
            do {
                // возвращаем в формате json в консоль
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
            
        }.resume()
    }
    
    // передача данных
    static func postRequest(url: String) {
        
        guard let url = URL(string: url) else { return }
        
        //данные для передачи
        let userData = ["Course": "Networking", "Lesson": "Get and Post Requests"]
        
        // запрос по ссылке
        var request = URLRequest(url: url)
        // определяем тип запроса чтобы поместить и передать данные
        request.httpMethod = "POST"
        
        // преобразуем наши данные в json(тело запроса)
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
        
        // помещаем данные в тело запроса для передачи на сервер
        request.httpBody = httpBody
        // формат передачи(определения ключа и значения)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        // Создает задачу, которая передает данные и извлекает содержимое указанного URL-адреса,а затем вызывает обработчик по завершении.
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in // тут передаем данные request на сервер и будем обратно их извлекать
            guard
                let response = response, // получаем ответ от сервера
                let data = data
                else { return }
            print(response)
            // делаем сериализацию перевод данных из одного типа в другой без потери данных
            do {
                // возвращаем в формате json в консоль
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    // загрузка изображения из интернета
    static func downloadImage(url: String, completion: @escaping (_ image: UIImage)->()) {
        
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }.resume()
    }
    
    // метод для загрузки данных для отображения в тейблвью(Courses)
    static func fetchData(url: String, completion: @escaping (_ courses: [Course])->()) {
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else { return }
            
            do {
                // конвертация написанных данных из Snake_stile в camelStyle (иногда в данных JSON используется написание переменных в стиле Snake_stile)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                // извлекаем из json
               let courses = try decoder.decode([Course].self, from: data)
                completion(courses)
                
            } catch let error {
                print("Error serilization json",error.localizedDescription)
            }
            
        }.resume()
    }
    
    // Метод для отправки изображения на сервер
    static func uploadImage(url: String) {
        
        let image = UIImage(named: "plum")!
        
        // словарь с параметрами авторизации
        let httpHeaders = ["Authorization": "Client-ID 117aba40d3e6bf4"]
        
        // извлечение картинки
        guard let imageProperties = ImageProperties(withImage: image, forKey: "image") else { return }
        
        guard let url = URL(string: url) else { return }
        
        // запрос к серверу
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // передаем параметры авторизации в заголовок запроса
        request.allHTTPHeaderFields = httpHeaders
        
        // помещаем в запрос данные для отправки на сервис (данные с нашим изображением)
        request.httpBody = imageProperties.data
        
        // выгружаем наше изображение на сервер dataTask(with: request) и получаем его обратно в (data, respons, error)
        URLSession.shared.dataTask(with: request) { (data, respons, error) in
            if let respons = respons {
                print(respons)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print("Error", error.localizedDescription)
                }
            }
        }.resume()
    }
    
}
