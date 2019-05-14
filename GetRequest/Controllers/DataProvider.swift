//
//  DataProvider.swift
//  GetRequest
//
//  Created by Давид on 14/05/2019.
//  Copyright © 2019 Давид. All rights reserved.
//

import UIKit

class DataProvider: NSObject {
    
    private var downloadTask: URLSessionDownloadTask!
    var fileLocation: ((URL) -> ())? // сюда передаем ссылку на наш временный файл
    var onProgress: ((Double) -> ())?
    
    // настройка конфигурации сессии
    private lazy var bgSession: URLSession = {
        // config определяет поведение сессии при загрузке и выгрузке данных
        // для создания параметра с возможностью фоновой загрузки данных вызываем метод background
        // в параметры background присваиваем Bundle identifier нашего приложения (в меню General)
        let config = URLSessionConfiguration.background(withIdentifier: "david.GetRequest")
        
        // оптимизация загрузки данных системой(например задержка загрузки данных пока устройство не будет подключенно к сети wi-fi)
//        config.isDiscretionary = true
        
        //по завершению загрузки данных приложение запустится в фоновом режиме
        config.sessionSendsLaunchEvents = true
        
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
        
        config.waitsForConnectivity = true // Ожидание подключения к сети(по умолчанию true)
        config.timeoutIntervalForResource = 300 // время ожидания сети в секундах
    }()
    
    // метод по загрузке данных
    func startDownload() {
        
        if let url = URL(string: "https://speed.hetzner.de/100MB.bin") {
            // копирование параметров конфигурации для настройки сеанса
            downloadTask = bgSession.downloadTask(with: url)
            // загрузка не раннее заданного времени
            downloadTask.earliestBeginDate = Date().addingTimeInterval(3)
            // верхня граница байтов которую клиент оправляет
            downloadTask.countOfBytesClientExpectsToSend = 512
            downloadTask.countOfBytesClientExpectsToReceive = 100 * 1024 * 1024
            downloadTask.resume()
        }
    }
    
    // мето для остановки загрузки данных
    func stopDownload() {
        downloadTask.cancel()
    }

}

extension DataProvider: URLSessionDelegate {
    // метод вызывается по завершению всех фоновых задач помещенных в очередь с нашим идентификатором приложения которые мы должны будем передать в appDelegate
    // так как sessionSendsLaunchEvents = true то по завершению фоовой передачи данных, приложение перезапустится и вызовет метод urlSessionDidFinishEvents
    // при запуске приложения в appDelegate должен вызваться соответствующий метод который будет перехватывать идентификатор нашей сессии 
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
        // сопоставление сессий
        // создаем константу completionHandler в которую передаем захваченное значение идентификатора нашей сессии из свойства bgSessionCompletionHandler из класса AppDelegate
        DispatchQueue.main.async {
            guard
                let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let completionHandler = appDelegate.bgSessionCompletionHandler
                else { return }
            // обнуляем значение свойства
            appDelegate.bgSessionCompletionHandler = nil
            // вызываем исходный блок чтобы уведомить систему что загрузка была звершена
            completionHandler()
        }
    }
}

extension DataProvider: URLSessionDownloadDelegate {
    //location содержит ссылку на временную директорию в которую сохраняется файл
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print("Did finish downloading: \(location.absoluteString)")
        
        DispatchQueue.main.async {
            self.fileLocation?(location)
        }
    }
    
    // отображения хода выполнения загрузки
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        // ожидаемы размер афйла !=
        guard totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown else { return }
        
        // результат деления кол-ва переданных байтов на общее кол-во
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        print("Download progress: \(progress)")
        
        // передаем значение деления в переменную onProgress
        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
    }
}

extension DataProvider: URLSessionTaskDelegate {
    
    // Восстановления соединения
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        
        // Ожидание соединения, обновления интерфейса и прочее
        
    }
}
