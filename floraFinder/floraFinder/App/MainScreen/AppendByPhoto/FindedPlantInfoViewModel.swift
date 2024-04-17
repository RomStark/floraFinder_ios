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
        service.getAllPlants(query: name).subscribe(onSuccess: { [weak self] plants in
            print(plants)
            print(plants[0].name)
            if plants.count == 1 {
                self?.plant = plants[0]
                self?.infoCellsRelay.accept((self?.cellsViewModels(plant: (self?.plant)!))!)
                self?.imageLoader(plants[0].imageURL).subscribe { [weak self] image in
                    self?.imageRelay.accept(image)
                }
                .disposed(by: self!.disposeBag)
            } else {
                self?.isGetPlantRelay.accept(true)
            }
        }).disposed(by: disposeBag)
    }


private func cellsViewModels(plant: Plant) -> [PlantInfoCellViewModel] {
    [PlantInfoCellViewModel(title: "название", value: plant.name),
     PlantInfoCellViewModel(title: "описание", value: plant.description),
     PlantInfoCellViewModel(title: "температурный режим", value: "\(plant.minT)-\(plant.maxT)C"),
     PlantInfoCellViewModel(title: "влажность", value: "\(plant.humidity)%"),
     PlantInfoCellViewModel(title: "Полив", value: "раз в \(plant.water_interval) дня"),
    ]
}
    
    private func addPlantToUser() {
        guard let plant else { return }
        let model = AddPlantDTO(
            givenName: "второе растение",
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
        isGetPlantRelay.asDriver(onErrorJustReturn: false)
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

