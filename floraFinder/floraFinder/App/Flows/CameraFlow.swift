//
//  CameraFlow.swift
//  floraFinder
//
//  Created by Al Stark on 15.04.2024.
//

import FunctionalNavigationFlowKit


func CameraFlow(
    in navigationController: UINavigationController,
    dependencies: CameraDependencies,
    type: String
) -> Flow {
    PushFlow(
        in: navigationController,
//        configuration: .combine([.hidesBottomBarWhenPushed, .title(Strings.Tab.notifications)]),
        CameraComposer.compose(
            dependencies: dependencies,
            flowDependencies: CameraFlowDependencies(openImageFlow: { image in
                OpenImageFlow(
                    in: navigationController,
                    dependencies: dependencies,
                    image: image,
                    type: type
                )()
            })
        )
    )
}
