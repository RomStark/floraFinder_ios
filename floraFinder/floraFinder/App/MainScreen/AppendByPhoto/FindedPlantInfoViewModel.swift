//
//  FindedPlantInfoViewModel.swift
//  floraFinder
//
//  Created by Al Stark on 17.04.2024.
//

import RxSwift
import RxCocoa


public final class FindedPlantInfoViewModel: FlowController {
    public enum Event {
//        case makePhoto(UIImage)
//        case openPlantInfo(String)
    }
    
    public var onComplete: CompletionBlock?
    
    private let disposeBag = DisposeBag()
    
    private let imageRelay = BehaviorRelay<UIImage?>(value: nil)
    private let infoCellsRelay = BehaviorRelay<[PlantInfoCellViewModel]>(value: [])
    private let isGetPlantRelay = BehaviorRelay<Bool>(value: false)
    
    private let service: UserService
//    private let plantModel: Plant
    private let imageLoader: ImageLoader
    private var plant: Plant?
    
    public init(name: String, service: UserService, imageLoader: @escaping ImageLoader) {

        self.service = service
        self.imageLoader = imageLoader
        service.getAllPlants(query: name).subscribe { [weak self] plants in
            self?.plant = plants[0]
        }.disposed(by: disposeBag)
        
        imageLoader(plant?.imageURL).subscribe { [weak self] image in
            self?.imageRelay.accept(image)
        }
        .disposed(by: disposeBag)
    }
    
    private func addPlantToUser() {
        guard let plant else { return }
        let model = AddPlantDTO(
            givenName: "",
            name: plant.name,
            description: plant.description,
            minT: plant.minT,
            maxT: plant.maxT,
            humidity: plant.humidity,
            water_interval: plant.water_interval,
            lighting: plant.lighting,
            imageURL: plant.imageURL,
            last_watering: Int(Date(timeIntervalSinceNow: 0).timeIntervalSince1970)
        )
        service.addPlant(model: model).subscribe(onSuccess: { [weak self] userPlant in
//            self?.onAdd()
            NotificationsService.createWateringNotification(identifier: userPlant.id, plant: userPlant.givenName, triggerTime: userPlant.water_interval)
        })
        .disposed(by: disposeBag)
    }
}


// MARK: - Биндинги для контроллера
extension FindedPlantInfoViewModel: FindedPlantInfoViewControllerBindings {
    public var isFindPlant: RxCocoa.Driver<Bool> {
        isGetPlantRelay.asDriver()
    }
    
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

