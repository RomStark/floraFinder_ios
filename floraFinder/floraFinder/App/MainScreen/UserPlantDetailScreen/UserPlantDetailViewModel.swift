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
        case deletePlant(String)
    }
    
    public var onComplete: CompletionBlock?
   
    
    private let disposeBag = DisposeBag()
    
    private let imageRelay = BehaviorRelay<UIImage?>(value: nil)
    private let infoCellsRelay = BehaviorRelay<[PlantInfoCellViewModel]>(value: [])
   
    
    private let service: UserService
    private let imageLoader: ImageLoader
    private let plant: UserPlant
    private let onDelete: () -> Void
    
    public init(plant: UserPlant, service: UserService, imageLoader: @escaping ImageLoader, onDelete: @escaping () -> Void) {
        self.plant = plant
        self.imageLoader = imageLoader
        self.service = service
        self.onDelete = onDelete
        imageLoader(plant.imageURL).subscribe { [weak self] image in
            self?.imageRelay.accept(image)
        }
        .disposed(by: disposeBag)
        infoCellsRelay.accept(cellsViewModels(plant: plant))
    }
    
    private func cellsViewModels(plant: UserPlant) -> [PlantInfoCellViewModel] {
        [PlantInfoCellViewModel(title: "название", value: plant.name),
         PlantInfoCellViewModel(title: "описание", value: plant.description),
         PlantInfoCellViewModel(title: "температурный режим", value: "\(plant.minT)-\(plant.maxT)C"),
         PlantInfoCellViewModel(title: "влажность", value: "\(plant.humidity)%"),
         PlantInfoCellViewModel(title: "Полив", value: "раз в \(plant.water_interval) дней"),
        ]
    }
    
    private func deletePlant() {
        service.deletePlant(id: plant.id).subscribe { [weak self] in
            self?.complete(.deletePlant("Растение удалено"))
            self?.onDelete()
        }.disposed(by: disposeBag)
    }
}

// MARK: - Биндинги для контроллера
extension UserPlantDetailViewModel: UserPlantDetailViewControllerBindings {
    public var deleteButtonTapped: RxSwift.Binder<Void> {
        Binder(self) { vm, _ in
            vm.deletePlant()
        }
    }
    
    public var image: RxCocoa.Driver<UIImage?> {
        imageRelay.asDriver(onErrorJustReturn: nil)
    }
    
    public var infoCells: RxCocoa.Driver<[PlantInfoCellViewModel]> {
        infoCellsRelay.asDriver(onErrorJustReturn: [])
    }
}
