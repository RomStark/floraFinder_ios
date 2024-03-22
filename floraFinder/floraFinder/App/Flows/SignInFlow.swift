//
//  SignInFlow.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import FunctionalNavigationFlowKit


func SignInFlow(
    window: UIWindow,
    dependencies: AuthDependencies,
    onLogin: @escaping Flow
) -> Flow {
    return SetWindowRootFlow(
        in: window,
        configuration: .combine(.keyAndVisible, .animated(duration: 0.3)),
        DeferredBuild(NavigationController.init) { (navigationController: UINavigationController) -> Flow in
            PushFlow(
                in: navigationController,
                configuration: .title("FloraFinder"),
                SignInComposer.compose(
                    dependencies: dependencies,
                    flowDependencies: SignInFlowDependencies(
                        onLogin: {
                            onLogin()
                        },
                        changeToLogin: {
                            LoginFlow(
                                in: navigationController,
                                dependencies: dependencies,
                                onLogin: onLogin
                            )()
                        }
                    )
                )
            )
        }
    )
}
