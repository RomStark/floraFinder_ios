//
//  UserPlantDetailViewModel.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import RxSwift
import RxCocoa


public final class UserPlantDetailViewModel: FlowController {
    public enum Event {
        
    }
    
    public var onComplete: CompletionBlock?
   
    
    private let disposeBag = DisposeBag()
    
    private let imageRelay = BehaviorRelay<UIImage?>(value: nil)
    private let infoCellsRelay = BehaviorRelay<[PlantInfoCellViewModel]>(value: [])
   
    
//    private let service: MainService
    private let imageLoader: ImageLoader
    private let plant: UserPlant
    
    public init(plant: UserPlant, imageLoader: @escaping ImageLoader) {
        self.plant = plant
        self.imageLoader = imageLoader
        
        imageLoader(plant.imageURL).subscribe { [weak self] image in
            self?.imageRelay.accept(image)
        }
        .disposed(by: disposeBag)
        infoCellsRelay.accept(cellsViewModels(plant: plant))
    }
    
    private func cellsViewModels(plant: UserPlant) -> [PlantInfoCellViewModel] {
        [PlantInfoCellViewModel(title: "название", value: plant.name),
         PlantInfoCellViewModel(title: "описание", value: plant.description),
        ]
    }
}

// MARK: - Биндинги для контроллера
extension UserPlantDetailViewModel: UserPlantDetailViewControllerBindings {
    public var image: RxCocoa.Driver<UIImage?> {
        imageRelay.asDriver(onErrorJustReturn: nil)
    }
    
    public var infoCells: RxCocoa.Driver<[PlantInfoCellViewModel]> {
        infoCellsRelay.asDriver(onErrorJustReturn: [])
    }
}
