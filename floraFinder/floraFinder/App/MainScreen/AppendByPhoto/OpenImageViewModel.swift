//
//  OpenImageViewModel.swift
//  floraFinder
//
//  Created by Al Stark on 17.04.2024.
//

import RxSwift
import RxCocoa


public final class OpenImageViewModel: FlowController {
    public enum Event {
//        case makePhoto(UIImage)
        case openPlantInfo(String)
    }
    
    public var onComplete: CompletionBlock?
    
    private let disposeBag = DisposeBag()
    
    private var mainImageRelay: BehaviorRelay<UIImage>
    
    private let service: UserService
    private let russDict = ["Anthurium_andraeanum": "андреанум", "Cirsium_vulgare": "бодяк"]
    public init(image: UIImage, service: UserService) {

        self.service = service
        mainImageRelay = BehaviorRelay<UIImage>(value: image)
    }
    
    private func sendImage() {
        service.sendImage(data: mainImageRelay.value.jpegData(compressionQuality: 1.0)!)
            .subscribe(onSuccess: { [weak self] response in
                print(response.real_name)
//                self?.complete(.openPlantInfo(response.real_name.replacingOccurrences(of: "_", with: " ")))
                if let russianName = self?.russDict[response.real_name] {
                    print("Русское название для Anthurium_andraeanum: \(russianName)")
                    self?.complete(.openPlantInfo(russianName))
                } else {
                    print("Нет русского названия для Anthurium_andraeanum")
                    self?.complete(.openPlantInfo(""))
                }
            }).disposed(by: disposeBag)
    }
}


// MARK: - Биндинги для контроллера
extension OpenImageViewModel: OpenImageViewControllerBindings {
    public var onContinueTapped: RxSwift.Binder<Void> {
        Binder(self) { vm, _ in
            vm.sendImage()
        }
    }
    
    public var image: RxCocoa.Driver<UIImage> {
        mainImageRelay.asDriver()
    }
}

