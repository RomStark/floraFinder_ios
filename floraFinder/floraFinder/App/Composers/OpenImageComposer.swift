//
//  OpenImageComposer.swift
//  floraFinder
//
//  Created by Al Stark on 17.04.2024.
//

import FunctionalNavigationFlowKit

protocol OpenImageDependencies  {
//    var mainService: MainService { get }
    var userService: UserService { get }
}

struct OpenImageFlowDependencies {
    
//    let plantInfoFlow: (Plant) -> ()
////
////    let allPlantFlow: Flow
//    let openCamera: () -> ()
}


enum OpenImageComposer {
    static func compose(
        dependencies: OpenImageDependencies,
        flowDependencies: OpenImageFlowDependencies,
        image: UIImage
    ) -> UIViewController {
        let viewModel = OpenImageViewModel(image: image, service: dependencies.userService)
        viewModel.onComplete = {
            switch $0 {
            case .openPlantInfo(let name):
                break
//            case let .plantInfo(model):
//                flowDependencies.plantInfoFlow(model)
//            case .allPlants:
//                flowDependencies.allPlantFlow()
            
            }
        }

        
        let viewController = OpenImageViewController()
//        viewController.bind(to: viewModel).dispose()
        viewController.subscription = LifetimeSubscription { [unowned viewController] in
            viewController.bind(to: viewModel)
        }
        
        return viewController
    }
}
