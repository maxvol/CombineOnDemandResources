//
//  ODRPublisher.swift
//  
//
//  Created by Maxim Volgin on 30/06/2021.
//

import Foundation
import Combine

@available(macOS 10, iOS 13, *)
public final class ODRPublisher: Publisher {
    
    public typealias Failure = Error
    public typealias Output = Progress
    
    static let keyPath = "fractionCompleted"
    
    private let request: NSBundleResourceRequest
        
    init(tags: Set<String>, bundle: Bundle? = nil) {
        self.request = bundle == nil ? NSBundleResourceRequest(tags: tags) : NSBundleResourceRequest(tags: tags, bundle: bundle!)
        self.request.loadingPriority = NSBundleResourceRequestLoadingPriorityUrgent
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Error == S.Failure, Progress == S.Input {
        let subscription = ODRSubscription(subscriber: subscriber, request: request)
        subscriber.receive(subscription: subscription)
        subscription.fetcher.fetch()
    }
    
}
