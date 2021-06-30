# CombineOnDemandResources

Access to on-demand resources via Combine

Example:.

```swift
Bundle
.main
.demandResources(withTags: ... ) // tags: Set<String>
.sink(receiveCompletion: { completion in
    switch completion {
    case .failure(let error):
        print(error)
    case .finished:
        print("done")
         if let url = Bundle.main.url(forResource: file, withExtension: "") {
            os_log("url: %@", log: Log.odr, type: .info, "\(url)")
            // TODO use your resource
         }
    }
},
receiveValue: { progress in
    self.showProgress(progress: Float(progress.fractionCompleted)) // declare your handler first
})
.store(in: &self.cancellables) // cancellables: Set<AnyCancellable>
```
