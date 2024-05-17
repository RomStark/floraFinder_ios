//
//  Extensions.swift
//  floraFinder
//
//  Created by Al Stark on 20.03.2024.
//

import UIKit
import RxSwift
import RxCocoa
import UIKit
import CoreML
import CoreImage
import DeclarativeLayoutKit

extension UIImage {
    func pixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
        var pixelBuffer: CVPixelBuffer?
        let options: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
        ]
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, options as CFDictionary, &pixelBuffer)
        
        guard status == kCVReturnSuccess else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
            return nil
        }
        
        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let widthFloat = Float(width)
        let heightFloat = Float(height)
        for y in 0..<height {
            for x in 0..<width {
                let pixel = pixelData!.advanced(by: (y * CVPixelBufferGetBytesPerRow(pixelBuffer!)) + (x * 4)).assumingMemoryBound(to: Float.self)
                let red = Float(pixel[2]) / 255.0
                let green = Float(pixel[1]) / 255.0
                let blue = Float(pixel[0]) / 255.0
                pixel[0] = blue
                pixel[1] = green
                pixel[2] = red
            }
        }
        return pixelBuffer
    }
}

public final class ToastView: UIView {
    init(frame: CGRect, text: String) {
        super.init(frame: frame)

        self.add {
            UIStackView().append {
                UILabel()
                    .set(fontStyle: .color(.gray))
                    .styledText(text)
            }
            .axis(.horizontal)
            .verticalAnchor(12)
            .horizontalAnchor(20)
        }
        .backgroundColor(.white)
        .cornerRadius(8)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


public extension ViewController {
    func showTopHint(text: String) {
        let toastView = ToastView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 48), text: text)
        view.add {
            toastView
                .topAnchor(16.to(self.view.safeAreaLayoutGuide.topAnchor))
                .horizontalAnchor(16)
                .heightAnchor(48)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.5, animations: {
                toastView.alpha = 0
            }, completion: { _ in
                toastView.removeFromSuperview()
            })
        }
    }
}

extension UIImage {
    func resize(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    
    func pixelBuffer() -> CVPixelBuffer? {
        let width = Int(self.size.width)
        let height = Int(self.size.height)
        
        var pixelBuffer: CVPixelBuffer? = nil
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
        ] as CFDictionary
        
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(buffer)
        
        guard let context = CGContext(data: pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(buffer), space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
            return nil
        }
        
        guard let cgImage = self.cgImage else {
            return nil
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        
        return buffer
    }
}

public typealias ImageLoader = (String?) -> Single<UIImage?>

public extension UIView {
    func asBarButtonItem() -> UIBarButtonItem {
        UIBarButtonItem(customView: self)
    }
}

extension Array: Disposable where Element == Disposable {
    public func dispose() {
        CompositeDisposable(disposables: self).dispose()
    }
}

@resultBuilder
public enum DisposableBuilder {
    public static func buildBlock(_ disposables: Disposable...) -> [Disposable] {
        disposables
    }
}


public extension UICollectionView {
    @discardableResult
    func register<CellClass: UICollectionViewCell>(_ cellClass: CellClass.Type) -> Self {
        register(
            cellClass,
            forCellWithReuseIdentifier: String(describing: cellClass)
        )
        
        return self
    }
}

extension UIStackView {
    public func clear() {
        for view in subviews { view.removeFromSuperview() }
    }
    
    public func set(views: [UIView]) {
        clear()
        for view in views {
            addArrangedSubview(view)
            
        }
        setNeedsLayout()
    }
    
    @discardableResult
    public func setLayoutMargins(_ newValue: UIEdgeInsets) -> Self {
        if !isLayoutMarginsRelativeArrangement {
            isLayoutMarginsRelativeArrangement(true)
        }
        
        layoutMargins(newValue)
        return self
    }
}


extension Reactive where Base: UIStackView {
    public var views: Binder<[UIView]> {
        Binder(base, binding: { stack, views in
            stack.set(views: views)
        })
    }
}
