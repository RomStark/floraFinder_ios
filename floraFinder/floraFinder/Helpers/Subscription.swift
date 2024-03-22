//
//  Subscription.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import Foundation
import RxSwift
//import Helpers


public protocol Subscription {
    func startIfNeeded()
    func stopIfNeeded()
}


public class LifetimeSubscription: Subscription {
    public typealias SubscriptionBuilder = () -> Disposable?
    
    let disposeBag = DisposeBag()
    var builder: SubscriptionBuilder
    var isStarted: Bool = false
    
    public init(@DisposableBuilder builder: @escaping SubscriptionBuilder) {
        self.builder = builder
    }
    
    public func startIfNeeded() {
        guard !isStarted, let disposable = builder() else {
            return
        }
        
        isStarted = true
        disposeBag.insert(disposable)
    }
    
    public func stopIfNeeded() {}
}


public class RestartingSubscription: Subscription {
    public typealias SubscriptionBuilder = () -> Disposable?
    
    var disposeBag: DisposeBag?
    var builder: SubscriptionBuilder
    
    public init(@DisposableBuilder builder: @escaping SubscriptionBuilder) {
        self.builder = builder
    }
    
    public func startIfNeeded() {
        disposeBag = DisposeBag()
        guard let disposable = builder() else {
            return
        }
        
        disposeBag?.insert(disposable)
    }
    
    public func stopIfNeeded() {
        disposeBag = DisposeBag()
    }
}
