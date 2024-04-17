//
//  CameraComposer.swift
//  floraFinder
//
//  Created by Al Stark on 15.04.2024.
//

import FunctionalNavigationFlowKit

protocol CameraDependencies: ImageLoadingDependencies, OpenImageDependencies  {
//    var mainService: MainService { get }
//    var userService: UserService { get }
}

struct CameraFlowDependencies {
    let openImageFlow: (UIImage) -> ()
//    let plantInfoFlow: (Plant) -> ()
////
////    let allPlantFlow: Flow
//    let openCamera: () -> ()
}


enum CameraComposer {
    static func compose(
        dependencies: CameraDependencies,
        flowDependencies: CameraFlowDependencies
    ) -> UIViewController {
        let viewModel = PlantByPhotoViewModel()
        viewModel.onComplete = {
            switch $0 {
            case let .makePhoto(image):
                flowDependencies.openImageFlow(image)
//            case let .plantInfo(model):
//                flowDependencies.plantInfoFlow(model)
//            case .allPlants:
//                flowDependencies.allPlantFlow()
            
            }
        }

        
        let viewController = PlantByPhotoViewController()
//        viewController.bind(to: viewModel).dispose()
        viewController.subscription = LifetimeSubscription { [unowned viewController] in
            viewController.bind(to: viewModel)
        }
        
        return viewController
    }
}
