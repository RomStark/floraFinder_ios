//
//  PlantsListViewModel.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import RxSwift
import RxCocoa


public final class PlantsListViewModel: FlowController {
    public enum Event {
        case plantInfo(Plant)
    }
    
    public var onComplete: CompletionBlock?
    

    
    private let newsSectionRelay = BehaviorRelay<[PlantSectionModel]>(value: [])
   
    
    private let disposeBag = DisposeBag()
    
    private let service: MainService
    private let imageLoader: ImageLoader
    
    public init(service: MainService, imageLoader: @escaping ImageLoader) {
        self.service = service
        self.imageLoader = imageLoader
        
        setupBindings()
    }
    
    func setupBindings() {
        service.getAllPlants()
            .subscribe(onSuccess: { [unowned self] plants in
                let models = plants.map { plant in
                    PlantCellViewModel(
                        model: plant,
                        imageLoader: self.imageLoader,
                        onTap: { [weak self] in
                            self?.onTapCell(plant)
                        })
                }
                
                self.newsSectionRelay.accept([
                    PlantSectionModel(model: "", items: models)
                ])
            })
            .disposed(by: disposeBag)
    }
    
    func onTapCell(_ model: Plant) {
        complete(.plantInfo(model))
    }
    
}

// MARK: - Биндинги для контроллера
extension PlantsListViewModel: PlantsListViewControllerBindings {
    public var plantsCells: RxCocoa.Driver<[PlantSectionModel]> {
        newsSectionRelay.asDriver().asDriver(onErrorJustReturn: [])
    }
}

