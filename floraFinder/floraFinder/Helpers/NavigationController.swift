//
//  NavigationController.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import UIKit
//import UIHelpers


final class NavigationController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    init() {
        super.init(nibName: nil, bundle: nil)

//        navigationBar.titleTextAttributes = FontStyle.smallMedium.attributes()
        navigationBar.barTintColor = .gray
        navigationBar.tintColor = .black
        navigationBar.barStyle = .blackTranslucent

        delegate = self
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        interactivePopGestureRecognizer?.delegate = self
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard navigationController.viewControllers.count > 1 else {
            return
        }

        viewController.navigationItem.leftBarButtonItem = Button()
            .image(UIImage(named: "arrowLeft"))
            .onTap({ [unowned self] in popViewController(animated: true) })
            .sizeAnchor(24)
            .activate()
            .asBarButtonItem()
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
}
