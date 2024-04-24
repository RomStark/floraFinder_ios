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
        //        case makePhoto(UIImage)
        //        case openPlantInfo(String)
    }
    
    public var onComplete: CompletionBlock?
    
    private let disposeBag = DisposeBag()
    
    private let imageRelay = BehaviorRelay<UIImage?>(value: nil)
    private let diseaseInfoRelay = BehaviorRelay<String>(value: "")
    
    private let service: UserService
    //    private let plantModel: Plant
    private let imageLoader: ImageLoader
    private var plant: Plant?
    private let russNames: [String:String] = ["bacterial_blight": "бактериальная гниль", "черная гниль": "бодяк",
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
        self.diseaseInfoRelay.accept("вероятнее всего \(russNames[name]!)")
    }
}


// MARK: - Биндинги для контроллера
extension DiseaseInfoViewModel: DiseaseInfoViewControllerBindings {
    public var image: RxCocoa.Driver<UIImage?> {
        imageRelay.asDriver(onErrorJustReturn: nil)
    }
    
    public var DiseaseInfo: RxCocoa.Driver<String> {
        diseaseInfoRelay.asDriver(onErrorJustReturn: "")
    }
}

