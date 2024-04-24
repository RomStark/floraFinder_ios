//
//  UserPlantDetailViewController.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import DeclarativeLayoutKit
import RxDataSources
import RxSwift
import RxCocoa


public protocol UserPlantDetailViewControllerBindings {
    var image: Driver<UIImage?> { get }
    var infoCells: Driver<[PlantInfoCellViewModel]> { get }
    var deleteButtonTapped: Binder<Void> { get }
}

public final class UserPlantDetailViewController: ViewController {
    private weak var mainImage: UIImageView!
    private weak var deleteButton: UIButton!
    private weak var scrollView: UIScrollView!
    
    private weak var settingsInfoStack: UIStackView!
    private weak var popButton: Button!
    
    
    public override func loadView() {
        view = mainView()
    }
    
    public func bind(to bindings: UserPlantDetailViewControllerBindings) -> Disposable {
        return [
            bindings.infoCells.map({ [unowned self] plants in
                plants.map { plant in
                    self.makeSettingsCell(with: plant)
                }
            }).drive(settingsInfoStack.rx.views),
            
            bindings.image.drive(mainImage.rx.image),
            deleteButton.rx.tap.bind(to: bindings.deleteButtonTapped)
        ]
    }
    
    private func makeSettingsCell(with viewModel: PlantInfoCellViewModel) -> UIView {
        let view = PlantInfoCellView()
        view.configure(with: viewModel)
        return view
    }
}


private extension UserPlantDetailViewController {
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
                        .topAnchor(10)
                        .heightAnchor(200)
                    
                    UIStackView()
                        .assign(to: &settingsInfoStack)
                        .axis(.vertical)
                        .spacing(20)
                        .horizontalAnchor(20)
                        .topAnchor(30.from(mainImage.bottomAnchor))
                    
                    UIButton()
                        .assign(to: &deleteButton)
                        .backgroundColor(.red)
                        .styledText("Удалить")
                        .cornerRadius(10)
                        .heightAnchor(42)
                        .horizontalAnchor(20)
                        .topAnchor(20.from(settingsInfoStack.bottomAnchor))
                        .bottomAnchor(80)
                    
                }
                .edgesAnchors()
                .widthAnchor(scrollView.widthAnchor)
                .heightAnchor(scrollView.heightAnchor.orLess)
                
            }
            .topAnchor(0)
            .bottomAnchor(mainView.bottomAnchor)
            .horizontalAnchor(0)
            .widthAnchor(mainView.widthAnchor)
        }
    }
}
