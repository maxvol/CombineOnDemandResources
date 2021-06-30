//
//  ODRFetcher.swift
//  
//
//  Created by Maxim Volgin on 30/06/2021.
//

import Foundation
import Combine
import os.log

@available(macOS 10, iOS 13, *)
final class ODRFetcher<S>: NSObject where S: Subscriber, S.Failure == Error, S.Input == Progress {

    let subscriber: S
    let request: NSBundleResourceRequest
    let progressObservingContext = UnsafeMutableRawPointer.init(bitPattern: 0)

    init(subscriber: S, request: NSBundleResourceRequest) {
        self.subscriber = subscriber
        self.request = request
    }

    func fetch() {
        request.conditionallyBeginAccessingResources { [unowned self] available in
            os_log("available: %@", log: Log.odr, type: .info, "\(available)")
            guard available else {
                self.kvoSubscribe()
                self.request.beginAccessingResources { [unowned self] error in
                    self.kvoUnsubscribe()
                    guard let error = error else {
                        os_log("downloaded", log: Log.odr, type: .info)
                        self.subscriber.receive(completion: .finished)
                        return
                    }
                    os_log("tags: %@ error: %@", log: Log.odr, type: .error, self.request.tags, error.localizedDescription)
                    self.subscriber.receive(completion: .failure(error))
                }
                return
            }
            self.subscriber.receive(completion: .finished)
        }
    }

    func cancel() {
        self.request.endAccessingResources()
    }

    // MARK:- KVO

    private func kvoSubscribe() {
        self.request.progress.addObserver(self, forKeyPath: ODRPublisher.keyPath, options: [.new, .initial], context: progressObservingContext)
    }

    private func kvoUnsubscribe() {
        self.request.progress.removeObserver(self, forKeyPath: ODRPublisher.keyPath)
    }

    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == progressObservingContext && keyPath == ODRPublisher.keyPath {
            let progress = object as! Progress
            _ = self.subscriber.receive(progress)
        }
    }

}
