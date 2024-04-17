//
//  PlantDetailViewController.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import DeclarativeLayoutKit
import RxDataSources
import RxSwift
import RxCocoa


public protocol PlantDetailViewControllerBindings {
    var image: Driver<UIImage?> { get }
    
    var infoCells: Driver<[PlantInfoCellViewModel]> { get }
    var addPlant: Binder<Void> { get }
}

public final class PlantDetailViewController: ViewController {
    private weak var mainImage: UIImageView!
    
    private weak var settingsInfoStack: UIStackView!
    private weak var addButton: Button!
    private weak var scrollView: UIScrollView!
    
    
    public override func loadView() {
        view = mainView()
    }
    
//    public override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.safeAreaLayoutGuide.layoutFrame.height)
//    }
    
    public func bind(to bindings: PlantDetailViewControllerBindings) -> Disposable {
        return [
            bindings.infoCells.map({ [unowned self] plants in
                plants.map { plant in
                    self.makeSettingsCell(with: plant)
                }
            }).drive(settingsInfoStack.rx.views),
            
            bindings.image.drive(mainImage.rx.image),
            addButton.rx.tap.bind(to: bindings.addPlant)
        ]
    }
    
    private func makeSettingsCell(with viewModel: PlantInfoCellViewModel) -> UIView {
        let view = PlantInfoCellView()
        view.configure(with: viewModel)
        return view
    }
    
}


private extension PlantDetailViewController {
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
                    
                    Button()
                        .assign(to: &addButton)
                        .backgroundColor(.blue)
                        .styledText("Добавить в сад")
                        .cornerRadius(8)
                        .heightAnchor(45)
                        .horizontalAnchor(20)
                        .topAnchor(30.from(settingsInfoStack.bottomAnchor))
                        .bottomAnchor(15)
                }
                .edgesAnchors()
                .widthAnchor(scrollView.widthAnchor)
                .heightAnchor(scrollView.heightAnchor.orLess)
                
            }
            .topAnchor(0)
            .bottomAnchor(commonView.bottomAnchor)
            .horizontalAnchor(0)
            .widthAnchor(commonView.widthAnchor)
            
        }
        
        //        return mainView.add {
        //
        //        }
    }
}
