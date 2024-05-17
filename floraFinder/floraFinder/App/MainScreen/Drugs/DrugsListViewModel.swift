//
//  DrugsListViewModel.swift
//  floraFinder
//
//  Created by Al Stark on 16.05.2024.
//


import RxSwift
import RxCocoa


public final class DrugsListViewModel: FlowController {
    public enum Event {
        case drugInfo(Drugs)
    }
    
    public var onComplete: CompletionBlock?
    private let drugsSectionRelay = BehaviorRelay<[DrugsSectionModel]>(value: [])
   
    
    private let disposeBag = DisposeBag()
    
    private let service: MainService
    private let imageLoader: ImageLoader
    
    public init(service: MainService, imageLoader: @escaping ImageLoader) {
        self.service = service
        self.imageLoader = imageLoader
        
        setupBindings()
    }
    
    func setupBindings() {
        service.getUserDrugs()
            .subscribe(onSuccess: { [unowned self] drugs in
                let models = drugs.map { drug in
                    DrugCellViewModel(
                        model: drug,
                        imageLoader: self.imageLoader,
                        onTap: { [weak self] in
                            self?.onTapCell(drug)
                        })
                }

                self.drugsSectionRelay.accept([
                    DrugsSectionModel(model: "", items: models)
                ])
            })
            .disposed(by: disposeBag)
    }
}

private extension DrugsListViewModel {
    func onTapCell(_ model: Drugs) {
        complete(.drugInfo(model))
    }
}

// MARK: - Биндинги для контроллера
extension DrugsListViewModel: DrugsListViewControllerBindings {
    public var drugsCells: RxCocoa.Driver<[DrugsSectionModel]> {
        drugsSectionRelay.asDriver().asDriver(onErrorJustReturn: [])
    }
}

