//
//  PlantDetailComposer.swift
//  floraFinder
//
//  Created by Al Stark on 22.03.2024.
//

import FunctionalNavigationFlowKit


struct PlantDetailFlowDependencies {
}


enum PlantDetailComposer {
    static func compose(
        dependencies: AllPlantsDependencies,
        flowDependencies: PlantDetailFlowDependencies,
        plant: Plant,
        onAdd: @escaping () -> Void
    ) -> UIViewController {
        let viewModel = PlantDetailViewModel(
            plant: plant,
            service: dependencies.userService,
            imageLoader: dependencies.imageLoader,
            onAdd: onAdd
        )
        viewModel.onComplete = {
            switch $0 {
                
            }
        }
        
        
        let viewController = PlantDetailViewController()
        viewController.subscription = LifetimeSubscription { [unowned viewController] in
            viewController.bind(to: viewModel)
        }
        
        return viewController
    }
}

