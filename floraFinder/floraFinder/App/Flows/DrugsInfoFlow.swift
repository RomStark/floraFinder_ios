//
//  DrugsInfoFlow.swift
//  floraFinder
//
//  Created by Al Stark on 16.05.2024.
//

import FunctionalNavigationFlowKit


func DrugsInfoFlow(
    in navigationController: UINavigationController,
    dependencies: UserDrugsDependencies,
    drug: Drugs
) -> Flow {
    PushFlow(
        in: navigationController,
        DrugsInfoComposer.compose(
            dependencies: dependencies,
            flowDependencies: DrugsInfoFlowDependencies(),
            drug: drug
        )
    )
}
