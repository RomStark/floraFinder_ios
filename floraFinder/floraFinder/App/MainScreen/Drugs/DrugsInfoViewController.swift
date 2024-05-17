//
//  DrugsInfoViewController.swift
//  floraFinder
//
//  Created by Al Stark on 16.05.2024.
//


import DeclarativeLayoutKit
import RxDataSources
import RxSwift
import RxCocoa


public protocol DrugsInfoViewControllerBindings {
    var image: Driver<UIImage?> { get }
    
    var infoCells: Driver<[DrugsInfoStackViewModel]> { get }
}

public final class DrugsInfoViewController: ViewController {
    private weak var mainImage: UIImageView!
    
    private weak var settingsInfoStack: UIStackView!
    private weak var scrollView: UIScrollView!
    
    
    public override func loadView() {
        view = mainView()
    }
    

    
    public func bind(to bindings: DrugsInfoViewControllerBindings) -> Disposable {
        return [
            bindings.infoCells.map({ [unowned self] drugs in
                drugs.map { drug in
                    self.makeSettingsCell(with: drug)
                }
            }).drive(settingsInfoStack.rx.views),
            
            bindings.image.drive(mainImage.rx.image),
        ]
    }
    
    private func makeSettingsCell(with viewModel: DrugsInfoStackViewModel) -> UIView {
        let view = DrugsInfoStackView()
        view.configure(with: viewModel)
        return view
    }
    
}


private extension DrugsInfoViewController {
    func mainView() -> UIView {
        let mainView = UIView()
            .backgroundColor(.mainBackGround)
        
        let scrollView = UIScrollView()
            .assign(to: &scrollView)
            .backgroundColor(.mainBackGround)
        let commonView = UIView()
            .backgroundColor(.mainBackGround)
        
        return commonView.add {
            scrollView.add {
                mainView.add {
                    UIImageView()
                        .assign(to: &mainImage)
                        .clipsToBounds(true)
                        .cornerRadius(15)
                        .horizontalAnchor(20)
                        .topAnchor(30)
                        .heightAnchor(200)
                    
                    
                    UIStackView()
                        .assign(to: &settingsInfoStack)
                        .axis(.vertical)
                        .spacing(15)
                        .horizontalAnchor(20)
                    //                .bottomAnchor(40)
                        .topAnchor(20.from(mainImage.bottomAnchor))
                        .bottomAnchor(15)
                }
                .edgesAnchors()
                .widthAnchor(scrollView.widthAnchor)
                .heightAnchor(scrollView.heightAnchor.orLess)
                
            }
            .topAnchor(20.from(commonView.safeAreaLayoutGuide.topAnchor))
            .bottomAnchor(mainView.bottomAnchor)
            .horizontalAnchor(0)
            .widthAnchor(mainView.widthAnchor)
            
        }
    }
}
