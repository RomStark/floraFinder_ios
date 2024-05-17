//
//  SettingsViewController.swift
//  floraFinder
//
//  Created by Al Stark on 15.05.2024.
//


import DeclarativeLayoutKit
import RxDataSources
import RxSwift
import RxCocoa


public protocol SettingsViewControllerBindings {
    var logOut: Binder<Void> { get }
    var toggleNotifications: Binder<Bool> { get }
}

public final class SettingsViewController: ViewController {
    private weak var logoutButton: Button!
    private weak var notificationsSwitch: UISwitch!
    
    public override func loadView() {
        view = mainView()
    }
    
    public func bind(to bindings: SettingsViewControllerBindings) -> Disposable {
        return [
            logoutButton.rx.tap.bind(to: bindings.logOut),
            notificationsSwitch.rx.isOn.bind(to: bindings.toggleNotifications)
        ]
    }
}

private extension SettingsViewController {
    func mainView() -> UIView {
        let mainView = UIView()
            .backgroundColor(.white)
            
       
        
        return mainView.add {
            UILabel()
                .styledText("Отключить уведомления")
                .topAnchor(20.from(mainView.safeAreaLayoutGuide.topAnchor))
                .leftAnchor(20)
                
            UISwitch()
                .assign(to: &notificationsSwitch)
                .topAnchor(20.from(mainView.safeAreaLayoutGuide.topAnchor))
                .rightAnchor(10)
            
            
            Button()
                .assign(to: &logoutButton)
                .set(fontStyle: .color(.red))
                .styledText("Выйти")
                .centerXAnchor()
                .topAnchor(30.from(notificationsSwitch.bottomAnchor))
                
           
        }
    }
}
