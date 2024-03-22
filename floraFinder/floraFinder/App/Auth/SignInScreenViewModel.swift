//
//  SignInScreenViewModel.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import RxSwift
import RxCocoa


public final class SignInScreenViewModel: FlowController {
    public enum Event {
        case login
        case changeToLogin
    }
    
    public var onComplete: CompletionBlock?
    
    
    private let disposeBag = DisposeBag()
    
    private let nameRelay = BehaviorRelay<String?>(value: nil)
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
        guard let login = loginRelay.value,
              let password = passwordRelay.value,
              let name = nameRelay.value else {
            return
        }
        
        service.signIn(login: login, password: password, name: name)
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
    
    public func updateName(_ name: String) {
        nameRelay.accept(name)
    }
}

// MARK: - Биндинги для контроллера
extension SignInScreenViewModel: SignInScreenViewControllerBindings {
    public var nameUpdate: RxSwift.Binder<String> {
        Binder(self) { vm, name in vm.updateName(name) }
    }
    
    public var needShowError: RxCocoa.Driver<Bool> {
        needShowErrorRelay.asDriver()
    }
    
    public var changeToLoginButtonTapped: RxSwift.Binder<Void> {
        Binder(self) { vm, _ in vm.complete(.changeToLogin) }
    }
    
    public var loginUpdate: RxSwift.Binder<String> {
        Binder(self) { vm, login in vm.updateUsername(login) }
    }
    
    public var passwordUpdate: RxSwift.Binder<String> {
        Binder(self) { vm, password in vm.updatePassword(password) }
    }
    
    public var signInIsEnabled: RxCocoa.Driver<Bool> {
        isSignInEnabled.asDriver(onErrorJustReturn: false)
    }
    
    public var signInButtonTapped: RxSwift.Binder<Void> {
        Binder(self) { vm, _ in vm.login() }
    }
}
