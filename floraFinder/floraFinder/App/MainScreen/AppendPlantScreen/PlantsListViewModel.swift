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
        case openCamera
    }
    
    public var onComplete: CompletionBlock?
    

    
    private let newsSectionRelay = BehaviorRelay<[PlantSectionModel]>(value: [])
    private let searchQueryRelay = BehaviorRelay<String?>(value: nil)
   
    
    private let disposeBag = DisposeBag()
    
    private let service: MainService
    private let imageLoader: ImageLoader
    
    public init(service: MainService, imageLoader: @escaping ImageLoader) {
        self.service = service
        self.imageLoader = imageLoader
        
//        setupBindings()
    }
    
    func setupBindings() {
        service.getAllPlants(query: "")
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
        
        searchQueryRelay.subscribe { [weak self] query in
            
        }
        .disposed(by: disposeBag)
    }
}

private extension PlantsListViewModel {
    func onTapCell(_ model: Plant) {
        complete(.plantInfo(model))
    }
    
    func acceptQuery(_ query: String) {
        
//        searchQueryRelay.accept(query)
    }
}

// MARK: - Биндинги для контроллера
extension PlantsListViewModel: PlantsListViewControllerBindings {
    public var tapCamera: RxSwift.Binder<Void> {
        Binder(self) { vm, _ in vm.complete(.openCamera) }
    }
    
    public var searchQuery: RxSwift.Binder<String> {
        Binder(self) { vm, query in
            print(query)
            vm.service.getAllPlants(query: query)
                .map({ (plants) -> [PlantCellViewModel] in
                    let models = plants.map { plant in
                        PlantCellViewModel(
                            model: plant,
                            imageLoader: vm.imageLoader,
                            onTap: {
                                vm.onTapCell(plant)
                            })
                    }
                    return models
                })
                .map({ models -> [PlantSectionModel] in
                    return [PlantSectionModel(model: "", items: models)]
                })
                .subscribe(onSuccess: { sections in
                    vm.newsSectionRelay.accept(sections)
                })
                .disposed(by: vm.disposeBag)
        }
    }
    
    public var plantsCells: RxCocoa.Driver<[PlantSectionModel]> {
        newsSectionRelay.asDriver().asDriver(onErrorJustReturn: [])
    }
}

