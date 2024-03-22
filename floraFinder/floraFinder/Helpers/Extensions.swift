//
//  Extensions.swift
//  floraFinder
//
//  Created by Al Stark on 20.03.2024.
//

import UIKit
import RxSwift
import RxCocoa

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
