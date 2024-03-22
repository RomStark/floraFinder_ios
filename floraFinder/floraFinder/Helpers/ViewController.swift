//
//  ViewController.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import UIKit


open class ViewController: UIViewController {
    open var subscription: Subscription?

    open override var canBecomeFirstResponder: Bool { true }
    
    /// Нужно для активации дебаг меню
    public var onShake: () -> Void

    public var onLoadView: () -> Void = {}
    public var onViewDidLoad: () -> Void = {} {
        didSet {
            if isViewLoaded { onViewDidLoad() }
        }
    }
    
    public var onViewWillDisappear: () -> Void = {}
    public var onViewWillAppear: () -> Void = {}

    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == UIEvent.EventSubtype.motionShake {
            onShake()
        }
    }
    
    open override func loadView() {
        onLoadView()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        subscription?.startIfNeeded()
        onViewWillAppear()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        subscription?.stopIfNeeded()
        onViewWillDisappear()
    }
    
    // УСТАНАВЛИВАТЬ ДЕФОЛТНЫЕ НАСТРОЙКИ ТУТ.
    public init() {
        onShake = ViewController.appearance().onShake
        super.init(nibName: nil, bundle: nil)
    }

    // ЗАДАВВАТЬ ДЕФОЛТНЫЕ НАСТРОЙКИ ТУТ. Если задавать там же где и обьявлена переменная получишь рекурсию
    fileprivate init(appearance: Void = ()) {
        onShake = {}
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("unavaliable")
    }
}


extension ViewController {
    private static let appearanceControlller = AppearanceViewController(appearance: ())

    /// Дефолтный конфиг при инициализации контроллера
    /// Не все свойства применяются, для этого нужно добавить соответствующую реализацию в ViewController.swift
    public static func appearance() -> ViewController { appearanceControlller }
}

private final class AppearanceViewController: ViewController {
    // swiftlint:disable:next unavailable_function
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fatalError("Этот контроллер не может использоваться для презентации!")
    }
}

