//
//  SettingsViewModel.swift
//  floraFinder
//
//  Created by Al Stark on 15.05.2024.
//


import RxSwift
import RxCocoa


public final class SettingsViewModel: FlowController {
    public enum Event {
        case logOut
    }
    
    public var onComplete: CompletionBlock?
   
    
    private let disposeBag = DisposeBag()
    
    
    public init() {
        
        
    }
    
}

private extension SettingsViewModel {
    
    
    func needSendNotifications(needSend: Bool) {
        
//        searchQueryRelay.accept(query)
    }
}

// MARK: - Биндинги для контроллера
extension SettingsViewModel: SettingsViewControllerBindings {
    public var logOut: RxSwift.Binder<Void> {
        Binder(self) { vm, _  in
            vm.complete(.logOut)
        }
    }
    
    public var toggleNotifications: RxSwift.Binder<Bool> {
        Binder(self) { vm, sendNotifications  in
            vm.needSendNotifications(needSend:sendNotifications)
        }
    }
}

