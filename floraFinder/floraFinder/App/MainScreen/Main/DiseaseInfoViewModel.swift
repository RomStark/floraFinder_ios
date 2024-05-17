//
//  DiseaseInfoViewModel.swift
//  floraFinder
//
//  Created by Al Stark on 24.04.2024.
//


import RxSwift
import RxCocoa


public final class DiseaseInfoViewModel: FlowController {
    public enum Event {
        case addDrug(String)
        //        case makePhoto(UIImage)
        //        case openPlantInfo(String)
    }

    public var onComplete: CompletionBlock?
    
    private let disposeBag = DisposeBag()
    
    private let imageRelay = BehaviorRelay<UIImage?>(value: nil)
    private let diseaseInfoRelay = BehaviorRelay<String>(value: "")
    private let diseaseModelRelay = BehaviorRelay<Disease>(value: Disease(uuid: "", name: "", description: "", drugs: []))
    private let drugsRelay = BehaviorRelay<[DrugsInfoCellViewModel]>(value: [])
    
    private let service: UserService
    //    private let plantModel: Plant
    private let imageLoader: ImageLoader
    private var plant: Plant?
    private let russNames: [String:String] = ["bacterial_blight": "бактериальная гниль", "black_rot": "бодяк",
                             "healthy": "здоровая",
                             "late_blight": "фитофтороз",
                             "mosaic": "мозаина",
                             "powdery_mildev": "мучнистая роса",
                             "rust": "ржавчина",
                             "spot": "андреанум",
                             "yellowish": "желтуха",]
    
    public init(name: String, service: UserService, imageLoader: @escaping ImageLoader) {
        print(name)
        self.service = service
        self.imageLoader = imageLoader
        
        self.diseaseInfoRelay.accept("вероятнее всего \(name)")
        getDisease(name: name)
    
    }
    
    private func getDisease(name: String) {
        service.getDisease(query: name).subscribe(onSuccess: { [weak self] disease in
            self?.diseaseModelRelay.accept(disease)
            
            
        })
        .disposed(by: disposeBag)
//            self?.diseaseModelRelay.accept(disease)
//            disease.map { a in
//                a.drugs.map { drug in
//                    <#code#>
//                }
//            }
//            self?.drugsRelay.accept([DrugsInfoCellViewModel])
        
    }
    
    private func addDrugToUser(id: String) {
        service.addDrug(id: id).subscribe(onCompleted: { [weak self] in
            self?.complete(.addDrug("Препарат добавлен в избранное"))
        }).disposed(by: disposeBag)
    }
}


// MARK: - Биндинги для контроллера
extension DiseaseInfoViewModel: DiseaseInfoViewControllerBindings {
    public var diseaseName: RxCocoa.Driver<String> {
        diseaseModelRelay.compactMap { disease in
            disease.name
        }.asDriver(onErrorJustReturn: "")
    }
    
    public var diseaseInfo: RxCocoa.Driver<String> {
        diseaseModelRelay.compactMap { disease in
            disease.description
        }.asDriver(onErrorJustReturn: "")
    }
    
    public var drugs: RxCocoa.Driver<[DrugsInfoCellViewModel]> {
        diseaseModelRelay.compactMap {  disease in
            disease.drugs.map { [unowned self] drug in
                DrugsInfoCellViewModel(
                    name: drug.name,
                    description: drug.description,
                    image: self.imageLoader(drug.imageURL).asObservable()) {
                        self.addDrugToUser(id: drug.id)
                    }
            }
        }.asDriver(onErrorJustReturn: [])
    }
    
    public var image: RxCocoa.Driver<UIImage?> {
        imageRelay.asDriver(onErrorJustReturn: nil)
    }
    
    public var DiseaseInfo: RxCocoa.Driver<String> {
        diseaseInfoRelay.asDriver(onErrorJustReturn: "")
    }
}

