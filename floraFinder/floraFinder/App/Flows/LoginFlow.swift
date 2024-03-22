//
//  LoginFlow.swift
//  floraFinder
//
//  Created by Al Stark on 22.03.2024.
//

import FunctionalNavigationFlowKit


func LoginFlow(
    in navigationController: UINavigationController,
    dependencies: AuthDependencies,
    onLogin: @escaping Flow
) -> Flow {
    PushFlow(
        in: navigationController,
        LoginComposer.compose(
            dependencies: dependencies,
            flowDependencies: LoginFlowDependencies(
                onLogin: onLogin,
                changeToSignIn: {
                    PopFlow(in: navigationController)()
                }
            )
        )
    )
}
