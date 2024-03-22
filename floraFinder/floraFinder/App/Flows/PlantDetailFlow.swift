//
//  PlantDetailFlow.swift
//  floraFinder
//
//  Created by Al Stark on 22.03.2024.
//

import FunctionalNavigationFlowKit


func PlantDetailFlow(
    in navigationController: UINavigationController,
    dependencies: AllPlantsDependencies,
    plant: Plant,
    onAdd: @escaping () -> Void
) -> Flow {
    PushFlow(
        in: navigationController,
        PlantDetailComposer.compose(
            dependencies: dependencies,
            flowDependencies: PlantDetailFlowDependencies(),
            plant: plant,
            onAdd: onAdd
        )
    )
}
