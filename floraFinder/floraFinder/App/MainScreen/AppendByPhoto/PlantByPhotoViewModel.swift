//
//  PlantByPhotoViewModel.swift
//  floraFinder
//
//  Created by Al Stark on 15.04.2024.
//


import RxSwift
import RxCocoa


public final class PlantByPhotoViewModel: FlowController {
    public enum Event {
        case makePhoto(UIImage)
    }
    
    public var onComplete: CompletionBlock?
    
    private let disposeBag = DisposeBag()
    
//    private let service: MainService
//    private let imageLoader: ImageLoader
    
    public init() {
//        self.service = service
//        self.imageLoader = imageLoader
        
    }
}


// MARK: - Биндинги для контроллера
extension PlantByPhotoViewModel: PlantByPhotoViewControllerBindings {
    public var makePhotoTapped: RxSwift.Binder<UIImage?> {
        Binder(self) { vm, image in
            guard let image else {
                return
            }
            vm.complete(.makePhoto(image))
        }
    }
}

