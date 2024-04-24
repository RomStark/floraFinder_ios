//
//  DiseaseInfoViewController.swift
//  floraFinder
//
//  Created by Al Stark on 24.04.2024.
//


import DeclarativeLayoutKit
import RxDataSources
import RxSwift
import RxCocoa
import AVFoundation


public protocol DiseaseInfoViewControllerBindings {
    var image: Driver<UIImage?> { get }
    
    var DiseaseInfo: Driver<String> { get }
}

public final class DiseaseInfoViewController: ViewController {
    private weak var mainImage: UIImageView!
    
    private weak var DiseaseInfo: UILabel!
    private weak var scrollView: UIScrollView!
    
    public override func loadView() {
        view = mainView()
    }
    
    
    
    public func bind(to bindings: DiseaseInfoViewControllerBindings) -> Disposable {
        return [
            bindings.DiseaseInfo.drive(DiseaseInfo.rx.text),
            
            bindings.image.drive(mainImage.rx.image),
        ]
    }
}

private extension DiseaseInfoViewController {
    func mainView() -> UIView {
        let mainView = UIView()
            .backgroundColor(.mainBackGround)
        
        let scrollView = UIScrollView()
            .assign(to: &scrollView)
            .backgroundColor(.mainBackGround)
        let commonView = UIView()
            .backgroundColor(.mainBackGround)
        
        return mainView.add {
            UIImageView()
                .assign(to: &mainImage)
                .clipsToBounds(true)
                .cornerRadius(15)
                .horizontalAnchor(20)
                .topAnchor(30)
                .heightAnchor(200)
            
            
            UILabel()
                .assign(to: &DiseaseInfo)
                .numberOfLines(0)
                .horizontalAnchor(20)
            //                .bottomAnchor(40)
                .topAnchor(30.from(mainImage.bottomAnchor))
                .bottomAnchor(30)
        }
    }
}
