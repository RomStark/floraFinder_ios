//
//  FontStyle.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import Foundation
import SwiftRichString


public final class FontStyle {
    let name: String?
    let handler: Style.StyleInitHandler
    
    init(name: String? = nil, handler: @escaping Style.StyleInitHandler) {
        self.name = name
        self.handler = handler
    }
    
    /// Возвращает стиль, зарегистрированный с именем name.
    /// Если имя nil или такой шрифт не зарегистрирован, то создает Style при помощи handler
    ///
    /// - Returns: Стиль, зарегистрированный по имени в StylesManager.shared
    /// или созданный с помощью handler
    public func style() -> StyleProtocol {
        if let name = name, let style = Styles.styles[name] {
            return style
        }
        
        return Style(handler)
    }
    
    func with(name: String) -> FontStyle {
        return FontStyle(name: name, handler: handler)
    }
}


extension FontStyle {
    public static func group(_ base: FontStyle, with additional: [String: FontStyle]) -> StyleGroup {
        StyleGroup(base: base.style(), additional.mapValues({ $0.style() }))
    }
    
    public static func compose(_ styles: FontStyle...) -> FontStyle {
        styles.flatten()
    }
    
    public func and(_ styles: FontStyle...) -> FontStyle {
        var resultStyles: [FontStyle] = [self]
        resultStyles.append(contentsOf: styles)
        return resultStyles.flatten()
    }
    
    public func attributes() -> [NSAttributedString.Key: Any] {
        let style = self.style()
        var attributes: [NSAttributedString.Key: Any] = style.attributes
        
        if attributes[NSAttributedString.Key.font] == nil {
            let font = style.fontData?.attributes(currentFont: nil, size: 75)[.font]
            attributes[NSAttributedString.Key.font] = font
        }
        
        return attributes
    }
    
    public func font() -> UIFont? {
        return attributes()[NSAttributedString.Key.font].flatMap({ $0 as? UIFont })
    }
    
    public func color() -> UIColor? {
        return attributes()[NSAttributedString.Key.foregroundColor].flatMap({ $0 as? UIColor })
    }
    
    func register() {
        guard let name = name else {
            return
        }
        
        Styles.register(name, style: Style(handler))
    }
}

extension Collection where Element == FontStyle {
    public func flatten() -> FontStyle {
        FontStyle(handler: { [self] style in
            self.forEach({ $0.handler(style) })
        })
    }
}

public extension FontStyle {
    static func + (_ lhs: FontStyle, _ rhs: FontStyle) -> FontStyle {
        .compose(lhs, rhs)
    }
}

public extension FontStyle {
//    /// medium,  size: 10, color: .primaryTexrInverted
//    static var xxxSmallMediumInverted: FontStyle {
//        .compose(.primary(.medium) + .size(.xxxSmall) + .color(.primaryTexrInverted))
//    }
//
//    /// medium, size: 12, color: .primaryGreen
//    static var xxSmallMediumPrimaryGreen: FontStyle {
//        .compose(.primary(.medium) + .size(.xxSmall) + .color(.primaryGreen))
//    }
//
//    /// medium, size: 12, color: .accentRed
//    static var xxSmallMediumAccentRed: FontStyle {
//        .compose(.primary(.medium) + .size(.xxSmall) + .color(.accentRed))
//    }
//
//    /// regular, size: 12, color: .primaryText
//    static var xxSmallRegularPrimaryText: FontStyle {
//        .compose(.primary(.regular) + .size(.xxSmall) + .color(.primaryText))
//    }
//
//    /// regular, size: 12, color: .secondaryText
//    static var xxSmallRegularSecodary: FontStyle {
//        .compose(.primary(.regular) + .size(.xxSmall) + .color(.secondaryText))
//    }
//
//    /// medium, size: 12, color: .secondaryText
//    static var xxSmallMediumSecondary: FontStyle {
//        .compose(.primary(.medium) + .size(.xxSmall) + .color(.secondaryText))
//    }
//
//    /// regular, size: 14, color: .primaryTexr
//    static var smallRegular: FontStyle {
//        .compose(.primary(.regular) + .size(.small) + .color(.primaryText))
////    }
//
//    /// regular, size: 14, color: .primaryTexrInverted
//    static var smallRegularInverted: FontStyle {
//        .compose(.primary(.regular) + .size(.small) + .color(.primaryTexrInverted))
//    }
//
//    /// medium, size: 14, color: .primaryTexr
//    static var smallMedium: FontStyle {
//        .compose(.primary(.medium) + .size(.small) + .color(.primaryText))
//    }
//
//    /// regular, size: 14, color: .secondaryText
//    static var smallRegularSecondary: FontStyle {
//        .compose(.primary(.regular) + .size(.small) + .color(.secondaryText))
//    }
//
//    /// medium, size: 14, color: .secondaryText
//    static var smallMediumSecondary: FontStyle {
//        .compose(.primary(.medium) + .size(.small) + .color(.secondaryText))
//    }
//
//    /// medium, size: 14, color: .accentRed
//    static var smallMediumAccentRed: FontStyle {
//        .compose(.primary(.medium) + .size(.small) + .color(.accentRed))
//    }
//
//    /// regular, size: 14, color: .invalid
//    static var smallRegularInvalid: FontStyle {
//        .compose(.primary(.regular) + .size(.small) + .color(.invalid))
//    }
//
//    /// medium, size: 14, color: .invalid
//    static var smallMediumInvalid: FontStyle {
//        .compose(.primary(.medium) + .size(.small) + .color(.invalid))
//    }
//
//    /// regular, size: 16, color: .warningText
//    static var mediumRegularWarningText: FontStyle {
//        .compose(.primary(.regular) + .size(.medium) + .color(.warningText))
//    }
//
//    /// medium, size: 16, color: .warningText
//    static var mediumMediumWarningText: FontStyle {
//        .compose(.primary(.medium) + .size(.medium) + .color(.warningText))
//    }
//
//    /// regular, size: 16, color: .primaryText
//    static var mediumRegularPrimaryText: FontStyle {
//        .compose(.primary(.regular) + .size(.medium) + .color(.primaryText))
//    }
//
//    /// regular, size: 16, color: .secondaryText
//    static var mediumRegularSecondaryText: FontStyle {
//        .compose(.primary(.regular) + .size(.medium) + .color(.secondaryText))
//    }
//
//    /// medium, size: 16, color: .primaryText
//    static var mediumMediumPrimaryText: FontStyle {
//        .compose(.primary(.medium) + .size(.medium) + .color(.primaryText))
//    }
//
//    /// medium, size: 16, color: .primaryTexrInverted
//    static var mediumInverted: FontStyle {
//        .compose(.primary(.medium) + .size(.medium) + .color(.primaryTexrInverted))
//    }
//
//    /// regular, size: 16, color: .hyperLink
//    static var mediumRegularHyperLink: FontStyle {
//        .compose(.primary(.regular) + .size(.medium) + .color(.hyperLink))
//    }
//
//    /// regular, size: 16, color: .linkText
//    static var mediumRegularLink: FontStyle {
//        .compose(.primary(.regular) + .size(.medium) + .color(.linkText))
//    }
//
//    /// medium, size: 20, color: .secondaryText
//    static var xLargeMediumSecondaryText: FontStyle {
//        .compose(.primary(.medium) + .size(.xLarge) + .color(.secondaryText))
//    }
//
//    /// medium, size: 20, color: .primaryText
//    static var xLargeMedium: FontStyle {
//        .compose(.primary(.medium) + .size(.xLarge) + .color(.primaryText))
//    }
}
