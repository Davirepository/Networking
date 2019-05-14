//
//  AppDelegate.swift
//  GetRequest
//
//  Created by Давид on 13/05/2019.
//  Copyright © 2019 Давид. All rights reserved.
//

import UIKit

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

}

