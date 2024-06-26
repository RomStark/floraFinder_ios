//
//  PlantDetailViewModel.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import RxSwift
import RxCocoa


public final class PlantDetailViewModel: FlowController {
    public enum Event {
    }
    
    public var onComplete: CompletionBlock?
   
    
    private let disposeBag = DisposeBag()
    
    private let imageRelay = BehaviorRelay<UIImage?>(value: nil)
    private let infoCellsRelay = BehaviorRelay<[PlantInfoCellViewModel]>(value: [])
   
    
    private let service: UserService
    private let imageLoader: ImageLoader
    private let plant: Plant
    private let onAdd: () -> Void
    
    public init(plant: Plant, service: UserService, imageLoader: @escaping ImageLoader, onAdd: @escaping () -> Void) {
        self.plant = plant
        self.service = service
        self.imageLoader = imageLoader
        self.onAdd = onAdd
        
        imageLoader(plant.imageURL).subscribe { [weak self] image in
            self?.imageRelay.accept(image)
        }
        .disposed(by: disposeBag)
        infoCellsRelay.accept(cellsViewModels(plant: plant))
    }
    
    private func cellsViewModels(plant: Plant) -> [PlantInfoCellViewModel] {
        [PlantInfoCellViewModel(title: "название", value: plant.name),
         PlantInfoCellViewModel(title: "описание", value: plant.description),
        ]
    }
    
    private func addPlantToUser() {
        let model = AddPlantDTO(
            givenName: "",
            name: plant.name,
            description: plant.description,
            minT: plant.minT,
            maxT: plant.maxT,
            humidity: plant.humidity,
            water_interval: plant.water_interval,
            lighting: plant.lighting,
            imageURL: plant.imageURL
        )
        service.addPlant(model: model).subscribe(onCompleted: { [weak self] in
            self?.onAdd()
        })
        .disposed(by: disposeBag)
    }
}

// MARK: - Биндинги для контроллера
extension PlantDetailViewModel: PlantDetailViewControllerBindings {
    public var addPlant: RxSwift.Binder<Void> {
        Binder(self) { vm, _ in vm.addPlantToUser() }
    }
    
    public var image: RxCocoa.Driver<UIImage?> {
        imageRelay.asDriver(onErrorJustReturn: nil)
    }
    
    public var infoCells: RxCocoa.Driver<[PlantInfoCellViewModel]> {
        infoCellsRelay.asDriver(onErrorJustReturn: [])
    }
}
