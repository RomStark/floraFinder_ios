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
//    var name: Driver<String> { get }
//    var description: Driver<String> { get }
//    var temp: Driver<String> { get }
//    var waterInterval: Driver<String> { get }
//    var humidity: Driver<String> { get }
//    var lightingLabel: Driver<String> { get }
    var infoCells: Driver<[PlantInfoCellViewModel]> { get }
}

public final class UserPlantDetailViewController: ViewController {
    private weak var mainImage: UIImageView!
//    private weak var nameLabel: UILabel!
//    private weak var givenNameLabel: UILabel!
//    private weak var descriptionLabel: UILabel!
//    private weak var tempLabel: UILabel!
//    private weak var lightingLabel: UILabel!
//    private weak var humidityLabel: UILabel!
//    private weak var waterIntervalLabel: UILabel!
    
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
            
            bindings.image.drive(mainImage.rx.image)
            
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
        
        
        return mainView.add {
            UIImageView()
                .assign(to: &mainImage)
                .clipsToBounds(true)
                .cornerRadius(15)
                .horizontalAnchor(20)
                .topAnchor(30.from(mainView.safeAreaLayoutGuide.topAnchor))
                .heightAnchor(200)
            
            
            UIStackView()
                .assign(to: &settingsInfoStack)
                .axis(.vertical)
                .spacing(20)
                .horizontalAnchor(20)
//                .bottomAnchor(40)
                .topAnchor(30.from(mainImage.bottomAnchor))
            
          
        }
    }
}
