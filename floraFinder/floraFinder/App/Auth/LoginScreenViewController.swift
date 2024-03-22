//
//  LoginScreenViewController.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import DeclarativeLayoutKit
import RxDataSources
import RxSwift
import RxCocoa


public protocol LoginScreenViewControllerBindings {
    var loginIsEnabled: Driver<Bool> { get }
    var loginButtonTapped: Binder<Void> { get }
    var changeToSignInButtonTapped: Binder<Void> { get }
    var loginUpdate: Binder<String> { get }
    var passwordUpdate: Binder<String> { get }
    var needShowError: Driver<Bool> { get }
}

public final class LoginScreenViewController: ViewController {
    
    private weak var loginTextField: UITextField!
    private weak var passwordTextField: UITextField!
    private weak var loginTextFieldContainer: UIView!
    private weak var passwordTextFieldContainer: UIView!
    private weak var logInButton: Button!
    private weak var changeToSignInButton: Button!
    private weak var errorLabel: UILabel!
    
    
    
    public override func loadView() {
        view = mainView()
        textFieldSettings()
    }
    
    public func bind(to bindings: LoginScreenViewControllerBindings) -> Disposable {
        return [
            bindings.loginIsEnabled.drive(logInButton.rx.isEnabled),
            bindings.loginIsEnabled.map({ isEnable in
                isEnable ? 1 : 0.5
            }).drive(logInButton.rx.alpha),
            logInButton.rx.tap.bind(to: bindings.loginButtonTapped),
            loginTextField.rx.text.asObservable().filter({ $0 != nil }).map({ $0! }).bind(to: bindings.loginUpdate),
            passwordTextField.rx.text.asObservable().filter({ $0 != nil }).map({ $0! }).bind(to: bindings.passwordUpdate),
            changeToSignInButton.rx.tap.bind(to: bindings.changeToSignInButtonTapped),
            bindings.needShowError.map{!$0}.drive(errorLabel.rx.isHidden),
        ]
    }
    
    private func textFieldSettings() {
        loginTextField.placeholder("Введите логин")
        passwordTextField.placeholder("Введите пароль")
        passwordTextField.isSecureTextEntry = true
        
    }
}


private extension LoginScreenViewController {
    func mainView() -> UIView {
        let mainView = UIView()
            .backgroundColor(.mainBackGround)
        
        
        return mainView.add {
            
            UILabel()
                .styledText("Авторизация")
                .set(fontStyle: .center, .size(.large))
                .horizontalAnchor(30)
                .topAnchor(50.from(mainView.safeAreaLayoutGuide.topAnchor))
            
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
                .topAnchor(100.from(mainView.safeAreaLayoutGuide.topAnchor))
            
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
                .styledText("Неверные данные")
                .centerXAnchor()
                .topAnchor(10.from(passwordTextFieldContainer.bottomAnchor))
            
            Button()
                .assign(to: &logInButton)
                .set(fontStyle: .color(.green))
                .styledText("Войти")
                .backgroundColor(.white)
                .cornerRadius(20)
                .heightAnchor(40)
                .horizontalAnchor(30)
                .topAnchor(45.from(passwordTextFieldContainer.bottomAnchor))
            
            Button()
                .assign(to: &changeToSignInButton)
                .set(fontStyle: .color(.darkGray))
                .styledText("Зарегистрироваться")
                .horizontalAnchor(0)
                .topAnchor(30.from(logInButton.bottomAnchor))
           
        }
    }
}
