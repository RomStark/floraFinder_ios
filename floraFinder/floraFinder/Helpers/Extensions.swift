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
