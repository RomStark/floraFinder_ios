//
//  FindedDiseaseFlow.swift
//  floraFinder
//
//  Created by Al Stark on 24.04.2024.
//

import FunctionalNavigationFlowKit

func FindedDiseaseFlow(
    in navigationController: UINavigationController,
    dependencies: FindedDiseaseDependencies,
    name: String
) -> Flow {
    PushFlow(
        in: navigationController,
        configuration: .hidesBottomBarWhenPushed,
        FindedDiseaseComposer.compose(
            dependencies: dependencies,
            flowDependencies: FindedDiseaseFlowDependencies(),
            name: name
        )
    )
}
