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
        configuration: .combine([.title("Мой Сад")]),
        MainScreensComposer.compose(
            dependencies: dependencies,
            onLogout: onLogout,
            flowDependencies: MainScreenFlowDependencies(
                plantInfoFlow: { plant, onDelete  in
                    UserPlantDetailFlow(
                        in: navigationController,
                        dependencies: dependencies,
                        plant: plant,
                        onDelete: onDelete
                    )()
                },
                allPlantFlow: { onAdd in
                    AllPlantsFlow(
                        in: navigationController,
                        dependencies: dependencies,
                        onAdd: onAdd
                    )()
                }, openCamera: {CameraFlow(in: navigationController, dependencies: dependencies, type: "disease")()},
                settingFlow: {
                    SettingsFlow(in: navigationController,
                                 dependencies: dependencies,
                                 onLogOut: onLogout)()
                },
                userDrugsFlow: {
                    UserDrugsFlow(in: navigationController,
                                  dependencies: dependencies)()
                }
            )
        )
    )
}
