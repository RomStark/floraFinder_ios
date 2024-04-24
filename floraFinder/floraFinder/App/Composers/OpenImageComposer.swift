//
//  OpenImageComposer.swift
//  floraFinder
//
//  Created by Al Stark on 17.04.2024.
//

import FunctionalNavigationFlowKit

protocol OpenImageDependencies: FindedPlantDependencies, FindedDiseaseDependencies  {
//    var mainService: MainService { get }
    var userService: UserService { get }
}

struct OpenImageFlowDependencies {
    
    let plantInfoFlow: (String) -> ()
    let diseaseInfoFlow: (String) -> ()
////
////    let allPlantFlow: Flow
//    let openCamera: () -> ()
}


enum OpenImageComposer {
    static func compose(
        dependencies: OpenImageDependencies,
        flowDependencies: OpenImageFlowDependencies,
        image: UIImage,
        type: String
    ) -> UIViewController {
        let viewModel = OpenImageViewModel(image: image, service: dependencies.userService, type: type)
        viewModel.onComplete = {
            switch $0 {
            case .openPlantInfo(let name):
                flowDependencies.plantInfoFlow(name)
//            case let .plantInfo(model):
//                flowDependencies.plantInfoFlow(model)
//            case .allPlants:
//                flowDependencies.allPlantFlow()
            
            case .openDiseaseInfo(let name):
                flowDependencies.diseaseInfoFlow(name)
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
