//
//  MainViewController.swift
//  GetRequest
//
//  Created by Давид on 13/05/2019.
//  Copyright © 2019 Давид. All rights reserved.
//

import UIKit
import UserNotifications // для push уведомлений

enum Actions: String, CaseIterable {
    
    case downloadImage = "Download Image"
    case get = "GET"
    case post = "POST"
    case ourCourses = "Our Courses"
    case uploadImage = "Upload Image"
    case downloadFile = "Download File"
}

// MARK: - Global Properties

private let reuseIdentifier = "Cell"
private let url = "http://jsonplaceholder.typicode.com/posts"
private let uploadImage = "https://api.imgur.com/3/image"


class MainViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    // массив пользовательских действий
//    let actions = ["Download Image", "GET", "POST", "Our Courses", "Upload Image"]
    let actions = Actions.allCases
    private var alert: UIAlertController!
    private let dataProvider = DataProvider()
    private var filePath: String?
    
    // MARK: -  viewDidLoad() Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // запрос к пользователю на отправку push уведомлений
        registerForNotification()
        
        
        dataProvider.fileLocation = { (location) in
            
            // Сохранить файл для дальнейшего использования
            print("Download finished: \(location.absoluteString)")
            self.filePath = location.absoluteString
            
            // убираем алерт конроллер после перезагрузки приложения
            self.alert.dismiss(animated: false, completion: nil)
            
            // приходит уведомление после загрузки файла
            self.postNotification()
        }
        
        
    }
    
    // MARK: - Methods
    
    private func showAlert() {
        
        alert = UIAlertController(title: "Downloading ...", message: "0%", preferredStyle: .alert)
        
        // констрейнт для высоты алерт контроллера
        let height = NSLayoutConstraint(
            item: alert.view,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 0,
            constant: 170
        )
        
        alert.view.addConstraint(height)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            
            self.dataProvider.stopDownload()
        }
        
        alert.addAction(cancelAction)
        // вызывая алерт контроллер добавляем в него новые элементы пользовательского интерфейса(activiti Indicator и proggress bar)
        present(alert, animated: true) {
            
            // размер activiti Indicator
            let size = CGSize(width: 40, height: 40)
            // расположение activiti Indicator
            // центр алертконтроллера = x: self.alert.view.frame.width / 2 и = y: self.alert.view.frame.height / 2
            // но нужно учитывать и размер activiti Indicator так в центре окажется только его угол модельки
            // поэтому из центра вычитаем половину размера activiti Indicator size.height / 2 и size.width / 2
            let point = CGPoint(x: self.alert.view.frame.width / 2 - size.width / 2, y: self.alert.view.frame.height / 2 - size.height / 2)
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
            activityIndicator.color = .gray
            activityIndicator.startAnimating()
            
            let progressView = UIProgressView(frame: CGRect(x: 0, y: self.alert.view.frame.height - 44, width: self.alert.view.frame.width, height: 2))
            progressView.tintColor = .blue
            
            // передаем перехваченный % загрузки в progressView в рельном времени
            self.dataProvider.onProgress = { (progress) in
                
                progressView.progress = Float(progress)
                self.alert.message = String(Int(progress * 100)) + "%"
            }
            
            self.alert.view.addSubview(activityIndicator)
            self.alert.view.addSubview(progressView)
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    
        cell.label.text = actions[indexPath.row].rawValue
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let action = actions[indexPath.row]
        
        switch action {
        case .downloadImage:
            performSegue(withIdentifier: "ShowImage", sender: self)
        case .get:
            NetworkManager.getRequest(url: url)
        case .post:
            NetworkManager.postRequest(url: url)
        case .ourCourses:
            performSegue(withIdentifier: "OurCourses", sender: self)
        case .uploadImage:
            NetworkManager.uploadImage(url: uploadImage)
        case .downloadFile:
            showAlert()
            dataProvider.startDownload()
        }
    }

}
extension MainViewController {
    
    // запрос к пользователю на отправку push уведомлений
    private func registerForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (_, _) in
            
        }
    }
    
    private func postNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Download complete!"
        content.body = "Your background transfer has completed. File path: \(filePath!)"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: "TransferComplete", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}



































