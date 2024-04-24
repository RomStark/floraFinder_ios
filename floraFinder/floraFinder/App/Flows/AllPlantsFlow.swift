//
//  AllPlantsFlow.swift
//  floraFinder
//
//  Created by Al Stark on 22.03.2024.
//

import FunctionalNavigationFlowKit


func AllPlantsFlow(
    in navigationController: UINavigationController,
    dependencies: AllPlantsDependencies,
    onAdd: @escaping () -> Void
) -> Flow {
    PushFlow(
        in: navigationController,
        AllPlantsComposer.compose(
            dependencies: dependencies,
            flowDependencies: AllPlantsFlowDependencies(
                plantInfoFlow: { plant in
                    PlantDetailFlow(
                        in: navigationController,
                        dependencies: dependencies,
                        plant: plant,
                        onAdd: onAdd
                    )()
                },
                openCamera: {
                    CameraFlow(in: navigationController, dependencies: dependencies, type: "plantInfo")()
                }
            )
        )
    )
}
