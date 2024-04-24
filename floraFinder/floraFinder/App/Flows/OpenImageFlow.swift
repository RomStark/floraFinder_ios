//
//  OpenImageFlow.swift
//  floraFinder
//
//  Created by Al Stark on 17.04.2024.
//

import FunctionalNavigationFlowKit

func OpenImageFlow(
    in navigationController: UINavigationController,
    dependencies: OpenImageDependencies,
    image: UIImage,
    type: String
) -> Flow {
    PushFlow(
        in: navigationController,
        OpenImageComposer.compose(
            dependencies: dependencies,
            flowDependencies: OpenImageFlowDependencies(plantInfoFlow: { name in
                FindedPlantFlow(
                    in: navigationController,
                    dependencies: dependencies,
                    name: name
                )()
            }, diseaseInfoFlow: { name in
                FindedDiseaseFlow(
                    in: navigationController,
                    dependencies: dependencies,
                    name: name
                )()
            }
                                                       ),
            image: image,
            type: type
        )
    )
}
