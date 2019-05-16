//
//  UserProfileVC.swift
//  GetRequest
//
//  Created by Давид on 16/05/2019.
//  Copyright © 2019 Давид. All rights reserved.
//

import UIKit
import FBSDKLoginKit

// Контроллер для выхода из профиля facebook

class UserProfileVC: UIViewController {
    
    //создания кнопки logIn/out facbook
    lazy var fbloginButton: UIButton = {
        let loginButton = FBSDKLoginButton()
        
        loginButton.frame = CGRect(x: 32,
                                   y: view.frame.height - 172,
                                   width: view.frame.width - 64,
                                   height: 50)
        loginButton.delegate = self
        return loginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        setupViews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    // метод для вызова создания кнопки logIn/out facbook
    private func setupViews() {
        view.addSubview(fbloginButton)
    }
    
}

// MARK: - Facebook SDK

// отслеживание правильности ввода
extension UserProfileVC: FBSDKLoginButtonDelegate {
    
    // отслеживает авторизацию
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print(error)
            return
        }
        
        print("Successfully logged in with facebook...")
    }
    
    // отслеживает выход
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        print("Did log out of facebook")
        openLogoutViewController()
        
    }
    
    private func openLogoutViewController() {
        
        // отслеживание регистрации пользователя
        //(если не зарегистрирован создаем контроллер LoginViewController и переходим туда)
        if !(FBSDKAccessToken.currentAccessTokenIsActive()) {
            
            // создание контроллера для регистрации и переход на него
            DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                
                self.present(loginViewController, animated: true)
                return
            }
        }

        
    }
    
}
