//
//  AuthScreenViewModel.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import RxSwift
import RxCocoa
import CoreML
import CoreImage
import WeatherKit


public final class LoginScreenViewModel: FlowController {
    public enum Event {
        case login
        case changeToSignIn
    }
    public var onComplete: CompletionBlock?
    private let disposeBag = DisposeBag()
    
    private let loginRelay = BehaviorRelay<String?>(value: nil)
    private let passwordRelay = BehaviorRelay<String?>(value: nil)
    private let needShowErrorRelay = BehaviorRelay<Bool>(value: false)
    
    public var isSignInEnabled: Observable<Bool> {
        Observable.combineLatest(loginRelay.asObservable(), passwordRelay.asObservable())
            .map { (username, password) in
                return !(username ?? "").isEmpty && !(password ?? "").isEmpty
            }
    }
    
    private let service: UserService
    
    
    public init(service: UserService) {
        self.service = service
        
       
        
    }
    
    
    private func login() {
        guard let login = loginRelay.value, let password = passwordRelay.value else {
            return
        }
        
        
        service.login(login: login, password: password)
            .subscribe(
                onCompleted: { [weak self] in
                    self?.complete(.login)
                    UserSettingsStorage.shared.savePassword(value: password)
                    UserSettingsStorage.shared.saveLogin(value: login)
                },
                onError: { [weak self] _ in
                    
                    self?.needShowErrorRelay.accept(true)
                })
            .disposed(by: disposeBag)
        
    }
    
    public func updateUsername(_ username: String) {
        loginRelay.accept(username)
    }
    
    public func updatePassword(_ password: String) {
        passwordRelay.accept(password)
    }
}

// MARK: - Биндинги для контроллера
extension LoginScreenViewModel: LoginScreenViewControllerBindings {
    public var needShowError: RxCocoa.Driver<Bool> {
        needShowErrorRelay.asDriver()
    }
    
    public var changeToSignInButtonTapped: RxSwift.Binder<Void> {
        Binder(self) { vm, _ in vm.complete(.changeToSignIn) }
    }
    
    public var loginUpdate: RxSwift.Binder<String> {
        Binder(self) { vm, login in vm.updateUsername(login) }
    }
    
    public var passwordUpdate: RxSwift.Binder<String> {
        Binder(self) { vm, password in vm.updatePassword(password) }
    }
    
    public var loginIsEnabled: RxCocoa.Driver<Bool> {
        isSignInEnabled.asDriver(onErrorJustReturn: false)
    }
    
    public var loginButtonTapped: RxSwift.Binder<Void> {
        Binder(self) { vm, _ in vm.login() }
    }
}
