//
//  OpenImageViewController.swift
//  floraFinder
//
//  Created by Al Stark on 17.04.2024.
//


import DeclarativeLayoutKit
import RxDataSources
import RxSwift
import RxCocoa
import AVFoundation


public protocol OpenImageViewControllerBindings {
    var image: Driver<UIImage> { get }
    var onContinueTapped: Binder<Void> { get }
}

public final class OpenImageViewController: ViewController {
    private weak var mainImageView: UIImageView!
    private weak var continueButton: UIButton!
    public override func loadView() {
        view = mainView()
    }
    
    
    
    public func bind(to bindings: OpenImageViewControllerBindings) -> Disposable {
        return [
            bindings.image.drive(mainImageView.rx.image),
            continueButton.rx.tap.bind(to: bindings.onContinueTapped)
        ]
    }
}

private extension OpenImageViewController {
    func mainView() -> UIView {
        let mainView = UIView()
            .backgroundColor(.mainBackGround)
        
        return mainView.add {
            UIImageView()
                .assign(to: &mainImageView)
                .verticalAnchor(0)
                .horizontalAnchor(0)
            
            UIButton()
                .assign(to: &continueButton)
                .add({
                    UILabel()
                        .text("Продолжить")
                        .centerXAnchor()
                        .verticalAnchor(0)
//                        .edgesAnchors()
                })
//                .styledText("Продолжить")
                .set(fontStyle: .color(.black))
                .set(fontStyle: .color(.black))
                .backgroundColor(.white)
                .cornerRadius(12)
                .heightAnchor(36)
                .horizontalAnchor(36)
                .centerXAnchor()
                .bottomAnchor(120)
        }
    }
}

