//
//  LoginVC.swift
//  LMCTestUIKit
//
//  Created by Vladislav Andreev on 16.09.2024.
//

import UIKit
import Security

///Окно авторизации
class LoginVC: UIViewController, UITextFieldDelegate {
    
    private let apiUtils = APIUtils()
    
    private let loginUtils = LoginUtils()
    
    ///Тайтл
    private let titleLable: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 70, weight: .regular)
        text.text = "KinoPoisk"
        text.textColor = Constants.Colors.color_neonBlue
        text.textAlignment = .center
        return text
    }()
    
    ///Поле ввода логина
    private let loginTextField: CustomTextField_Login = {
        let textField = CustomTextField_Login()
        textField.placeholder = "Логин"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    ///Поле ввода пароля
    private let passwordTextField: CustomTextField_Login = {
        let textField = CustomTextField_Login()
        textField.placeholder = "Пароль"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        return textField
    }()
    
    ///Кнопка видимости пароля
    private let buttonPassVisib: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("", for: .normal)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.tintColor = Constants.Colors.color_neonBlue
        button.backgroundColor = .clear
        return button
    }()
    
    /// false - пароль невиден
    /// true - пароль виден
    private var flag_PassVisib = false
    
    ///Кнопка "Войти"
    private let buttonLogin: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = Constants.Colors.color_neonBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.layer.cornerRadius = 5
        return button
    }()
    
    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        ///Цвет фона
        view.backgroundColor = Constants.Colors.color_background
        
        addActions()
        addSubview()
        setConstrains()
        
        /// Удаление всех зарегестрированных  пользователей при необходимости
//        self.loginUtils.deleteAllAccounts()
       
    }
    
    //MARK: добавление действий
    private func addActions(){
        
        buttonLogin.addAction(UIAction(handler: { _ in
            guard let login = self.loginTextField.text, !login.isEmpty,
                  let password = self.passwordTextField.text, !password.isEmpty else {
                APIUtils.showAlert(on: self, message: "Введите логин и пароль")
                return
            }
            
            // Проверка, зарегистрирован ли пользователь
            if let savedPassword = self.loginUtils.loadPassword(for: login) {
                if savedPassword == password {
                    //APIUtils.showAlert(on: self, message: "Успешный вход")
                    let vc = HomeVC()
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    self.present(vc, animated: true)
                } else {
                    APIUtils.showAlert(on: self, message: "Неверный пароль")
                }
            } else {
                // Регистрация нового пользователя
                self.loginUtils.saveLogin(login: login, password: password)
//                APIUtils.showAlert(on: self, message: "Регистрация успешна")
                let vc = HomeVC()
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true)
            }
        }), for: .touchUpInside)
        
        buttonPassVisib.addAction(UIAction(handler: { [weak self] _ in
            if !self!.flag_PassVisib {
                self!.flag_PassVisib.toggle()
                self!.buttonPassVisib.setImage(UIImage(systemName: "eye"), for: .normal)
                self!.passwordTextField.isSecureTextEntry = false
            } else {
                self!.flag_PassVisib.toggle()
                self!.buttonPassVisib.setImage(UIImage(systemName: "eye.slash"), for: .normal)
                self!.passwordTextField.isSecureTextEntry = true
            }
        }), for: .touchUpInside)
        
    }
    
    //MARK: добавление view на экран
    private func addSubview() {
        view.addSubview(titleLable)
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(buttonLogin)
        view.addSubview(buttonPassVisib)
    }
    
    //MARK: констреинты
    private func setConstrains(){
        
        NSLayoutConstraint.activate([
            
            titleLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLable.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            
            loginTextField.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 50),
            loginTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            loginTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            loginTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            buttonPassVisib.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
            buttonPassVisib.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -20),
            
            buttonLogin.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonLogin.heightAnchor.constraint(equalToConstant: 50),
            buttonLogin.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            buttonLogin.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 100),
            
            
        ])
    }
    
}

