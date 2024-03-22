//
//  MainScreenFlow.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import FunctionalNavigationFlowKit


func MainScreenFlow(
    in navigationController: UINavigationController,
    dependencies: MainScreenDependencies,
    onLogout: @escaping Flow
) -> Flow {
    PushFlow(
        in: navigationController,
        MainScreensComposer.compose(
            dependencies: dependencies,
            flowDependencies: MainScreenFlowDependencies(
                plantInfoFlow: { plant in
                    UserPlantDetailFlow(
                        in: navigationController,
                        dependencies: dependencies,
                        plant: plant
                    )()
                },
                allPlantFlow: { onAdd in
                    AllPlantsFlow(
                        in: navigationController,
                        dependencies: dependencies,
                        onAdd: onAdd
                    )()
                }
            )
        )
    )
}
