//
//  ODRSubscription.swift
//  
//
//  Created by Maxim Volgin on 30/06/2021.
//

import Foundation
import Combine
import os.log

@available(macOS 10, iOS 13, *)
final class ODRSubscription<S: Subscriber>: Subscription where S.Input == Progress, S.Failure == Error {
    
    let fetcher: ODRFetcher<S>
    
    init(subscriber: S, request: NSBundleResourceRequest) {
        self.fetcher = ODRFetcher(subscriber: subscriber, request: request)
    }
    
    func request(_ demand: Subscribers.Demand) {
        // noop
    }
    
    func cancel() {
        os_log("cancelled for tags: %@", log: Log.odr, type: .info, fetcher.request.tags)
        fetcher.cancel()
    }
    
}
