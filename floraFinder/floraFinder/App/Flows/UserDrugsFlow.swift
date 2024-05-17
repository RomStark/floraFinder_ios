//
//  UserDrugsFlow.swift
//  floraFinder
//
//  Created by Al Stark on 16.05.2024.
//

import FunctionalNavigationFlowKit


func UserDrugsFlow(
    in navigationController: UINavigationController,
    dependencies: UserDrugsDependencies
) -> Flow {
    PushFlow(
        in: navigationController,
        UserDrugsComposer.compose(
            dependencies: dependencies,
            flowDependencies: UserDrugsFlowDependencies(drugInfoFlow: { drug in
                DrugsInfoFlow(in: navigationController,
                              dependencies: dependencies,
                              drug: drug
                )()
            })
        )
    )
}
