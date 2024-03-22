//
//  SignInScreenViewController.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import DeclarativeLayoutKit
import RxDataSources
import RxSwift
import RxCocoa


public protocol SignInScreenViewControllerBindings {
    var signInIsEnabled: Driver<Bool> { get }
    var signInButtonTapped: Binder<Void> { get }
    var changeToLoginButtonTapped: Binder<Void> { get }
    var loginUpdate: Binder<String> { get }
    var passwordUpdate: Binder<String> { get }
    var nameUpdate: Binder<String> { get }
    var needShowError: Driver<Bool> { get }
}

public final class SignInScreenViewController: ViewController {
    private weak var nameTextField: UITextField!
    private weak var loginTextField: UITextField!
    private weak var passwordTextField: UITextField!
    private weak var nameTextFieldContainer: UIView!
    private weak var loginTextFieldContainer: UIView!
    private weak var passwordTextFieldContainer: UIView!
    private weak var sigInButton: Button!
    private weak var changeToLoginButton: Button!
    private weak var errorLabel: UILabel!
    
    
    
    public override func loadView() {
        view = mainView()
        textFieldSettings()
    }
    
    public func bind(to bindings: SignInScreenViewControllerBindings) -> Disposable {
        return [
            bindings.signInIsEnabled.drive(sigInButton.rx.isEnabled),
            bindings.signInIsEnabled.map({ isEnable in
                isEnable ? 1 : 0.5
            }).drive(sigInButton.rx.alpha),
            bindings.needShowError.map{!$0}.drive(errorLabel.rx.isHidden),
            
            
            sigInButton.rx.tap.bind(to: bindings.signInButtonTapped),
            nameTextField.rx.text.asObservable().filter({ $0 != nil }).map({ $0! }).bind(to: bindings.nameUpdate),
            loginTextField.rx.text.asObservable().filter({ $0 != nil }).map({ $0! }).bind(to: bindings.loginUpdate),
            passwordTextField.rx.text.asObservable().filter({ $0 != nil }).map({ $0! }).bind(to: bindings.passwordUpdate),
            changeToLoginButton.rx.tap.bind(to: bindings.changeToLoginButtonTapped),
        ]
    }
    
    private func textFieldSettings() {
        nameTextField.placeholder("ВВедите имя")
        loginTextField.placeholder("Введите логин")
        passwordTextField.placeholder("Введите пароль")
        passwordTextField.isSecureTextEntry = true
    }
}


private extension SignInScreenViewController {
    func mainView() -> UIView {
        let mainView = UIView()
            .backgroundColor(.mainBackGround)
        
        
        return mainView.add {
            
            UILabel()
                .styledText("Регистрация")
                .set(fontStyle: .center, .size(.large))
                .horizontalAnchor(30)
                .topAnchor(50.from(mainView.safeAreaLayoutGuide.topAnchor))
            
            UIView()
                .assign(to: &nameTextFieldContainer)
                .backgroundColor(.white)
                .add {
                    UITextField()
                        .assign(to: &nameTextField)
                        .backgroundColor(.white)
                        .heightAnchor(45)
                        .horizontalAnchor(15)
                        .verticalAnchor(5)
                }
                .cornerRadius(8)
                .horizontalAnchor(30)
                .topAnchor(100.from(mainView.safeAreaLayoutGuide.topAnchor))
            
            UIView()
                .assign(to: &loginTextFieldContainer)
                .backgroundColor(.white)
                .add {
                    UITextField()
                        .assign(to: &loginTextField)
                        .backgroundColor(.white)
                        .heightAnchor(45)
                        .horizontalAnchor(15)
                        .verticalAnchor(5)
                }
                .cornerRadius(8)
                .horizontalAnchor(30)
                .topAnchor(30.from(nameTextField.bottomAnchor))
            
            UIView()
                .assign(to: &passwordTextFieldContainer)
                .backgroundColor(.white)
                .add {
                    UITextField()
                        .assign(to: &passwordTextField)
                        .backgroundColor(.white)
                        .heightAnchor(45)
                        .horizontalAnchor(15)
                        .verticalAnchor(5)
                }
                .cornerRadius(8)
                .horizontalAnchor(30)
                .topAnchor(30.from(loginTextFieldContainer.bottomAnchor))
            
            UILabel()
                .assign(to: &errorLabel)
                .set(fontStyle: .color(.red), .size(.xSmall))
                .styledText("Пользователь с таким логином существует")
                .centerXAnchor()
                .topAnchor(10.from(passwordTextFieldContainer.bottomAnchor))
                
            
            Button()
                .assign(to: &sigInButton)
                .set(fontStyle: .color(.green))
                .styledText("Зарегистрироваться")
                .backgroundColor(.white)
                .cornerRadius(20)
                .heightAnchor(40)
                .horizontalAnchor(30)
                .topAnchor(45.from(passwordTextFieldContainer.bottomAnchor))
                
            Button()
                .assign(to: &changeToLoginButton)
                .set(fontStyle: .color(.darkGray))
                .styledText("Войти")
                .horizontalAnchor(0)
                .topAnchor(30.from(sigInButton.bottomAnchor))
           
        }
    }
}
