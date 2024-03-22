//
//  FlowController.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import Foundation


public protocol FlowController {
    associatedtype Event
    typealias CompletionBlock = (Event) -> ()
    
    var onComplete: CompletionBlock? { get set }
    
    func complete(_ event: Event)
}

public extension FlowController {
    func complete(_ event: Event) {
        guard !Thread.isMainThread else {
            onComplete?(event)
            return
        }

        DispatchQueue.main.async{
            self.onComplete?(event)
        }
    }
}
