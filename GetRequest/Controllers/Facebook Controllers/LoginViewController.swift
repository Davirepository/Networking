//
//  LoginViewController.swift
//  GetRequest
//
//  Created by Давид on 16/05/2019.
//  Copyright © 2019 Давид. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

// Контроллер для входа в профиль facebook

class LoginViewController: UIViewController {
    
    //создания кнопки logIn/out facbook
    lazy var fbloginButton: UIButton = {
        let loginButton = FBSDKLoginButton()
        
        loginButton.frame = CGRect(x: 32, y: 360, width: view.frame.width - 64, height: 50)
        loginButton.delegate = self
        return loginButton
    }()
    
    // создание кастомной кнопки для авторизации через facebook
    lazy var customFBLoginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.backgroundColor = UIColor(hexValue: "#3B5999", alpha: 1)
        loginButton.setTitle("Login with Facebook", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.frame = CGRect(x: 32, y: 360 + 60, width: view.frame.width - 64, height: 50)
        loginButton.layer.cornerRadius = 4
        loginButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
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
        view.addSubview(customFBLoginButton)
    }
    
}

// MARK: - Facebook SDK

// отслеживание правильности ввода
extension LoginViewController: FBSDKLoginButtonDelegate {
    
    // отслеживает авторизацию
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print(error)
            return
        }
        
        // если пользователь зарегистрирован(токен активен) то переходим на меинвьюконтроллер
        guard FBSDKAccessToken.currentAccessTokenIsActive() else { return }
        openMainViewController()
        
        print("Successfully logged in with facebook...")
    }
    
    // отслеживает выход
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        print("Did log out of facebook")
        
    }
    
    // закрытие(выгрузка из памяти) текущего вьюконтроллера и переход на главный
    private func openMainViewController() {
        dismiss(animated: true)
    }
    
    // метод для кастомной кнопки
    // логика авторизации пользователя в Facebook
    @objc private func handleCustomFBLogin() {
        
        FBSDKLoginManager().logIn(
            withReadPermissions: ["email", "public_profile"], from: self){ (result, error) in
            
                // если есть ошибка выходим из метода
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let result = result else { return }
                
                // если пользователь нажал на кнопку зарегистрирваться, то переходим на сайт фейсбука
                // но на сайте он может отменить регистрацию
                // поэтому проверяем result(результат) на действие отмены и если действие отменено возвращаем его на экран логина
                // если же он зарегистрировался то открываеем MainViewController()
                if result.isCancelled { return }
                else {
                    self.signIntoFirebase()
                    
                    // вызываем метод для закрытия(выгрузка из памяти) текущего вьюконтроллера и перехода на главный экран
                    self.openMainViewController()
                }
        }
    }
    
    private func signIntoFirebase() {
        
        let accessToken = FBSDKAccessToken.current()
        
        guard let accessTokenString = accessToken?.tokenString else { return }
        // передаем текущий токен пользователя facebook в сервис firebase для последующей его регистрации в этом сервисе
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        // авторизуем пользователя в базе firebase с учетными данными facebook
        // signInAndRetrieveData - ассинхронный вход в firebase с предоставленными сторонними учетными данными
        // credentials - учетные данные, user - авторизованный пользователь
        Auth.auth().signInAndRetrieveData(with: credentials) { (user, error) in
            
            if let error = error {
                print("Something wrong with our facebook user: ", error)
                return
            }
            
            print("Successfully logged in with our FB user: ", user!)
        }
    }
}
