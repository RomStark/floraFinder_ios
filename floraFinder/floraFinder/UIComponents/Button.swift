//
//  Button.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import UIKit
import RxSwift
import RxCocoa


open class Button: UIButton {
    private let disposeBag = DisposeBag()

    public private(set) var appearances: [UIControl.State: Appearance] = [:]

    open override var isHighlighted: Bool {
        didSet { updateAppearance() }
    }

    open override var isEnabled: Bool {
        didSet { updateAppearance() }
    }

    open override var isSelected: Bool {
        didSet { updateAppearance() }
    }

    open override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
        update(appearance: { $0.image = .value(image) }, for: state)
    }

    private func updateAppearance() {
        guard let appearance = appearances[state] else {
            return
        }

        if let alpha = appearance.alpha {
            self.alpha = alpha
        }

        if let backgroundColor = appearance.backgroundColor {
            self.backgroundColor = backgroundColor
        }

        if let (width, color) = appearance.border {
            self.layer.borderColor = color.cgColor
            self.layer.borderWidth = width
        }

        switch appearance.image {
        case .value(let image):
            super.setImage(image, for: state)
        case .empty:
            super.setImage(nil, for: state)
        }

//        if let fontStyle = appearance.fontStyle {
//            set(fontStyle: fontStyle)
//            styledText = styledText
//        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    open func commonInit() {
        set(appearance: Appearance(button: self), for: .normal, .selected, .highlighted, .disabled)
        update(appearance: { $0.alpha = 0.7 }, for: .highlighted)
    }

    @discardableResult
    open func set(appearance: Appearance, for states: UIControl.State...) -> Self {
        for state in states {
            appearances[state] = appearance
        }

        updateAppearance()

        return self
    }

    @discardableResult
    open func update(appearance transform: (inout Appearance) -> Void, for states: UIControl.State...) -> Self {
        for state in states {
            var new = appearances[state] ?? Appearance(button: self)
            transform(&new)
            appearances[state] = new
        }

        return self
    }

    public var tapAreaInset: UIEdgeInsets = .zero

    @discardableResult
    open func setTapAreaInset(_ newValue: UIEdgeInsets) -> Self {
        tapAreaInset = newValue
        return self
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        bounds.inset(by: tapAreaInset).contains(point)
    }
}


public extension Button.Appearance {
    init(button: UIButton) {
        self.init(alpha: button.alpha, backgroundColor: button.backgroundColor, image: .value(button.imageView?.image), fontStyle: nil)
    }
}


extension Button {
    public struct Appearance {
        public enum ImageAppearance {
            case value(UIImage?)
            case empty
        }

        var alpha: CGFloat?
        var backgroundColor: UIColor?
        var image: ImageAppearance
        var fontStyle: FontStyle?
        var border: (width: CGFloat, color: UIColor)?

        public init(
            alpha: CGFloat? = nil,
            backgroundColor: UIColor? = nil,
            image: ImageAppearance = .empty,
            fontStyle: FontStyle? = nil,
            border: (width: CGFloat, color: UIColor)? = nil
        ) {
            self.alpha = alpha
            self.backgroundColor = backgroundColor
            self.image = image
            self.fontStyle = fontStyle
            self.border = border
        }
    }
}


extension UIControl.State: Hashable {
    static func == (lhs: UIControl.State, rhs: UIControl.State) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
