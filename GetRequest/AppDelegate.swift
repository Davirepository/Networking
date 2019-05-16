//
//  AppDelegate.swift
//  GetRequest
//
//  Created by Давид on 13/05/2019.
//  Copyright © 2019 Давид. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase


let primaryColor = UIColor(red: 210/255, green: 109/255, blue: 128/255, alpha: 1)
let secondaryColor = UIColor(red: 107/255, green: 148/255, blue: 230/255, alpha: 1)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // свойство для сохранения параметра из completionHandler метода handleEventsForBackgroundURLSession
    // опциональное замыкание в качестве типа
    var bgSessionCompletionHandler: (() -> ())?

    // в блок completionHandler будет передаваться сообщение с индентификатор сессии вызывающего запуск приложения
    // при запуске приложения снова создается сессия для фоновой загрузки данных которая автоматически связывается с текущей фоновой активностью
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        
        bgSessionCompletionHandler = completionHandler
    }
    
    // след 2 метода для
    // инициализация facebook SDK при запуске приложение
    // обработка результатов (вход/ выход/ вход с последней зарегистрированной странцы)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // добавление конфигурации FirebaseApp
        FirebaseApp.configure()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let appId = FBSDKSettings.appID
        
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(String(describing: appId))") && url.host == "authorize" {
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        }
        
        return false
    }

}

