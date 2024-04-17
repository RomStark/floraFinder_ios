//
//  FindedPlantFlow.swift
//  floraFinder
//
//  Created by Al Stark on 17.04.2024.
//

import FunctionalNavigationFlowKit

func FindedPlantFlow(
    in navigationController: UINavigationController,
    dependencies: FindedPlantDependencies,
    name: String
) -> Flow {
    PushFlow(
        in: navigationController,
        FindedPlantComposer.compose(
            dependencies: dependencies,
            flowDependencies: FindedPlantFlowDependencies(),
            name: name
        )
    )
}
