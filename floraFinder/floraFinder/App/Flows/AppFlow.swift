//
//  AppFlow.swift
//  floraFinder
//
//  Created by Al Stark on 20.03.2024.
//

import FunctionalNavigationFlowKit
import RxSwift


enum AppState {
    case authorized
    case notAuthorized
    
    static var currentState: AppState {
        let isAuth: Bool = UserSettingsStorage.shared.retrieve(key: .isAuthorized) ?? false
        return  isAuth ? .authorized : .notAuthorized
       
    }
}


final class AppFlow {
    private let window: UIWindow?
    private let appDependencies: AppDependencies
    private let disposeBag = DisposeBag()
    
    init(window: UIWindow?, appDependencies: AppDependencies) {
        self.window = window
        self.appDependencies = appDependencies
        
        appDependencies.setOnLogout({ [weak self] in self?.runPrepareLogout() })
    }
    
    func runAppFlow() {
        FontStyle.registerAll()
        runPrepareLogout()
//        runAuthFlow()
//        runMainFlow()
//        switch AppState.currentState {
//        case .authorized:
//            runMainFlow()
//        case .notAuthorized:
//            runAuthFlow()
//        }
    }

//    // MARK: - Prepare
//    func runPrepareMainFlow() {
//        guard let window else {
//            return
//        }
//
//        EssentialDataLoadingFlow(
//            window: window,
//            loader: appDependencies.mainFlowLoader,
//            completion: { [weak self] in self?.runMainFlow() }
//        )()
//    }

    func runPrepareLogout() {
        UserSettingsStorage.shared.clear(key: .isAuthorized)
        UserSettingsStorage.shared.clear(key: .password)
        UserSettingsStorage.shared.clear(key: .login)
        runAuthFlow()
    }

    // MARK: - Run
    func runMainFlow() {
        guard let window else {
            return
        }
        
        MainFlow(
            window: window,
            dependencies: appDependencies,
            logoutFlow: { [weak self] in self?.runPrepareLogout() }
        )()
        
//        requestPushAuthorization()
    }

    func runAuthFlow() {
        guard let window else {
            return
        }
        
        SignInFlow(
            window: window,
            dependencies: appDependencies,
            onLogin: { [weak self] in self?.finishAuth() }
        )()
    }

    // MARK: - Finish
    private func finishAuth() {
        UserSettingsStorage.shared.save(key: .isAuthorized, value: true).subscribe(onCompleted: { [weak self] in
            self?.runMainFlow()
        }).disposed(by: disposeBag)
    }

    // MARK: - Notifications
//    private func requestPushAuthorization() {
//        notificationsService?.requestAuthorization(completion: { [weak self] result in
//            if case .success = result {
//                onMainThread(UIApplication.shared.registerForRemoteNotifications)()
//                self?.appDependencies.canSendPushToken(true)
//            }
//        })
//    }
}

