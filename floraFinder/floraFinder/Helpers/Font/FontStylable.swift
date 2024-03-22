//
//  FontStylable.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//


import DeclarativeLayoutKit
import UIKit
import SwiftRichString
import RxSwift
import RxCocoa


public protocol FontStylable: AnyObject {
    var styledText: String? { get set }

    func set(fontStyle: FontStyle...) -> Self
}

extension FontStylable {
    @discardableResult
    public func styledText(_ text: String) -> Self {
        self.styledText = text
        return self
    }
}

extension UILabel: FontStylable {
    @discardableResult
    public func set(fontStyle: FontStyle...) -> Self {
        self.style = fontStyle.flatten().and(FontStyle.truncatingTail).style()
        return self
    }
}

extension UIButton: FontStylable {
    @discardableResult
    public func set(fontStyle: FontStyle...) -> Self {
        self.titleLabel?.set(fontStyle: fontStyle.flatten())
        return self
    }
}

extension UITextField: FontStylable {
    @discardableResult
    public func set(fontStyle: FontStyle...) -> Self {
        let attributes = fontStyle.flatten().attributes()

        self.style = fontStyle.flatten().style()
        self.defaultTextAttributes = attributes
        self.typingAttributes = attributes

        return self
    }
}

extension UITextView: FontStylable {
    @discardableResult
    public func set(fontStyle: FontStyle...) -> Self {
        self.style = fontStyle.flatten().style()
        return self
    }
}

@objc extension UIButton {
    public var styledText: String? {
        get {
            attributedTitle(for: .normal)?.string ?? title(for: .normal)
        }
        set {
            guard let style = titleLabel?.style else {
                setTitle(newValue, for: .normal)
                return
            }
            
            setAttributedTitle(newValue?.set(style: style), for: .normal)
            setAttributedTitle(newValue?.set(style: style), for: .highlighted)
            setAttributedTitle(newValue?.set(style: style), for: .selected)
            setAttributedTitle(newValue?.set(style: style), for: .disabled)
        }
    }
}


extension Reactive where Base: FontStylable {
    public var styledText: Binder<String?> {
        Binder<String?>(base, binding: { stylable, text in
            stylable.styledText = text ?? ""
        })
    }
}

//extension Reactive where Base: Button {
//    public var setViewStyle: Binder<ViewStyle<Button>> {
//        Binder(base) { base, viewStyle in
//            base.set(viewStyle: viewStyle)
//        }
//    }
//}

extension String {
    public func set(fontStyle styles: FontStyle...) -> SwiftRichString.AttributedString {
        self.set(style: styles.flatten().style())
    }
}

extension NSMutableAttributedString {
    public func set(fontStyle: FontStyle...) -> SwiftRichString.AttributedString {
        self.set(style: fontStyle.flatten().style())
    }
}
