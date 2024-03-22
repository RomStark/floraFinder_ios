//
//  FontStyles.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import UIKit
import SwiftRichString


// MARK: - Registration
extension FontStyle {
    
    /// Регистрирует все стили
    /// Вызывается в AppConfiguring
    public static func registerAll() {
//        loadAllFonts()
        
        let styles = [
//            primary(.regular),
//            primary(.medium),

            left,
            right,
            center,

            underlined,

            size(.xxSmall),
            size(.xSmall),
            size(.small),
            size(.medium),
            size(.large),
            size(.xLarge),
            size(.xxLarge),
            size(.xxxLarge),
        ]
        
        styles.forEach({ $0.register() })
    }
}


// MARK: - Colors
extension FontStyle {
    public static func color(_ color: UIColor) -> FontStyle {
        FontStyle { $0.color = color }
    }
}


//// MARK: - Fonts
//public enum FontWeight: String {
//    case regular
//    case medium
//}

//extension FontStyle {
//    public static func font(_ font: FontConvertible) -> FontStyle {
//        FontStyle {
//            $0.font = font.font(size: nil)
//        }.with(name: font.font(size: nil).familyName)
//    }
//
//    public static func primary(_ weight: FontWeight = .regular) -> FontStyle {
//        switch weight {
//        case .regular:
//            return font("HelveticaNeueCyr-Roman")
//        case .medium:
//            return font("HelveticaNeueCyr-Medium")
//        }
//    }
//}


// MARK: - Sizes
public struct FontSize {
    public let value: CGFloat
    var name: String { "FontSize_\(value)" }
    
    /// 10
    public static let xxxSmall: FontSize = .init(value: 10.0)
    /// 12
    public static let xxSmall: FontSize = .init(value: 12.0)
    /// 13
    public static let xSmall: FontSize = .init(value: 13.0)
    /// 14
    public static let small: FontSize = .init(value: 14.0)
    /// 16
    public static let medium: FontSize = .init(value: 16.0)
    /// 18
    public static let large: FontSize = .init(value: 18.0)
    /// 20
    public static let xLarge: FontSize = .init(value: 20.0)
    /// 22
    public static let xxLarge: FontSize = .init(value: 22.0)
    /// 24
    public static let xxxLarge: FontSize = .init(value: 24.0)

    /// 15
    public static let h1: FontSize = .init(value: 15.0)
    /// 17
    public static let h2: FontSize = .init(value: 17.0)
    /// 32
    public static let largeHeader: FontSize = .init(value: 32)
    
    /// 28
    public static let onboardingTitle: FontSize = .init(value: 28)
}

extension FontStyle {
    public static func size(_ size: FontSize) -> FontStyle {
        let styleName: String = "FontSize_\(String(format: "%.2f", size.value))"
        
        return FontStyle(handler: {
            $0.size = size.value
        })
        .with(name: styleName)
    }
}


// MARK: - Alignment
extension FontStyle {
    public static let left = FontStyle {
        $0.alignment = .left
    }.with(name: "left")
    
    public static let right = FontStyle {
        $0.alignment = .right
    }.with(name: "right")
    
    public static let center = FontStyle {
        $0.alignment = .center
    }.with(name: "center")
}


// MARK: - Other
extension FontStyle {
    public static let underlined = FontStyle {
        $0.underline = (.single, nil)
    }.with(name: "underlined")
    
    public static func lineHeight(multiple: CGFloat) -> FontStyle {
        FontStyle { $0.lineHeightMultiple = multiple }
    }
    
    public static func lineHeight(_ lineHeight: CGFloat) -> FontStyle {
        FontStyle {
            $0.minimumLineHeight = lineHeight
            $0.maximumLineHeight = lineHeight
        }
    }
    
    public static var truncatingTail: FontStyle {
        FontStyle { $0.lineBreakMode = .byTruncatingTail }
    }

    /// Интервал между буквами
    public static func kern(_ value: CGFloat) -> FontStyle {
        FontStyle { $0.kerning = .point(value) }
    }
    
    public static func strikethrough(color: UIColor) -> FontStyle {
        FontStyle { $0.strikethrough = (style: .single, color: color) }
    }

    /// Отступ первой строки
    public static func firstLineHeadIndent(_ indent: CGFloat) -> FontStyle {
        FontStyle { $0.firstLineHeadIndent = indent }
    }

    public static func paragraphSpacingAfter(_ value: CGFloat) -> FontStyle {
        FontStyle { $0.paragraphSpacingAfter = value }
    }
    
    public static func link(_ url: URL) -> FontStyle {
        FontStyle { $0.linkURL = url }
    }
}


//private func loadAllFonts() {
//    let bundle = Bundle(for: FontStyle.self)
//    
//    let fontsUrls = bundle.urls(forResourcesWithExtension: "otf", subdirectory: nil) ?? []
//    
//    for url in fontsUrls {
//        guard let fontData = NSData(contentsOf: url),
//              let dataProvider = CGDataProvider(data: fontData),
//              let fontRef = CGFont(dataProvider) else {
//            fatalError("Либо неправильные пути к шрифтам, либо хз")
//        }
//        
//        var errorRef: Unmanaged<CFError>?
//        CTFontManagerRegisterGraphicsFont(fontRef, &errorRef)
//    }
//}
