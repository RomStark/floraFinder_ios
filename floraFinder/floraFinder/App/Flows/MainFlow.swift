//
//  MainFlow.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import FunctionalNavigationFlowKit


func MainFlow(
    window: UIWindow,
    dependencies: AppDependencies,
    logoutFlow: @escaping Flow
) -> Flow {
    return SetWindowRootFlow(
        in: window,
        configuration: .combine(.keyAndVisible, .animated(duration: 0.3)),
        DeferredBuild(NavigationController.init) { (navigationController: UINavigationController) -> Flow in
            MainScreenFlow(
                in: navigationController,
                dependencies: dependencies,
                onLogout: logoutFlow
            )
        })
}
