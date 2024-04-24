//
//  UserPlantDetailFlow.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import FunctionalNavigationFlowKit


func UserPlantDetailFlow(
    in navigationController: UINavigationController,
    dependencies: UserPlantDetailDependencies,
    plant: UserPlant,
    onDelete: @escaping () -> Void
) -> Flow {
    PushFlow(
        in: navigationController,
        UserPlantDetailComposer.compose(
            dependencies: dependencies,
            flowDependencies: UserPlantDetailFlowDependencies(),
            plant: plant,
            onDelete: onDelete
        )
    )
}
