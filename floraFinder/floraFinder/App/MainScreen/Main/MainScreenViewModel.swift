//
//  MainScreenViewModel.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//


import RxSwift
import RxCocoa


public final class MainScreenViewModel: FlowController {
    public enum Event {
        case plantInfo(UserPlant)
        case allPlants(() -> Void)

    }
    
    public var onComplete: CompletionBlock?
    

    
    private let newsSectionRelay = BehaviorRelay<[UserPlantSectionModel]>(value: [])
   
    
    private let disposeBag = DisposeBag()
    
    private let service: MainService
    private let imageLoader: ImageLoader
    
    public init(service: MainService, imageLoader: @escaping ImageLoader) {
        self.service = service
        self.imageLoader = imageLoader
        
        setupBindings()
    }
    
    func setupBindings() {
        service.getAllUserPlants()
            .subscribe(onSuccess: { [unowned self] plants in
                let models = plants.map { plant in
                    UserPlantCellViewModel(
                        model: plant,
                        imageLoader: self.imageLoader,
                        onTap: { [weak self] in
                            self?.onTapCell(plant)
                        },
                        onTapWatering: { [weak self] in
                            self?.onTapWatering(plant)
                        }
                    )
                }
                
                self.newsSectionRelay.accept([
                    UserPlantSectionModel(model: "", items: models)
                ])
            })
            .disposed(by: disposeBag)
    }
    
    func onTapCell(_ model: UserPlant) {
        complete(.plantInfo(model))
    }
    func onTapWatering(_ model: UserPlant) {
        let plant = UpdatePlantDTO(
            givenName: model.givenName,
            name: model.name,
            description: model.description,
            minT: model.minT,
            maxT: model.maxT,
            humidity: model.humidity,
            water_interval: model.water_interval,
            lighting: model.lighting,
            imageURL: model.imageURL,
            last_watering: Int(Date(timeIntervalSinceNow: 0).timeIntervalSince1970)
        )
        service.updatePlant(model: plant, id: model.id).subscribe(onCompleted: { [weak self] in
//            self?.onAdd()
        })
        .disposed(by: disposeBag)
    }
}

// MARK: - Биндинги для контроллера
extension MainScreenViewModel: MainScreenViewControllerBindings {
    public var openAllPlantsList: RxSwift.Binder<Void> {
        Binder(self) { vm, _ in vm.complete(.allPlants({ [weak self] in
            self?.setupBindings()
        })) }
    }
    
    public var plantsCells: RxCocoa.Driver<[UserPlantSectionModel]> {
        newsSectionRelay.asDriver().asDriver(onErrorJustReturn: [])
    }
}

