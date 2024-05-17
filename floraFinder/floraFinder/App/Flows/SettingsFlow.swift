//
//  SettingsFlow.swift
//  floraFinder
//
//  Created by Al Stark on 15.05.2024.
//

import FunctionalNavigationFlowKit


func SettingsFlow(
    in navigationController: UINavigationController,
    dependencies: SettingsDependencies,
    onLogOut: @escaping Flow
) -> Flow {
    PushFlow(
        in: navigationController,
        configuration: .title("Настройки"),
        SettingsComposer.compose(
            dependencies: dependencies,
            flowDependencies: SettingsFlowDependencies(logout: onLogOut)
        )
    )
}
