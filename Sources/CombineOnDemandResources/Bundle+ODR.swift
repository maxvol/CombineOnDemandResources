//
//  Bundle+ODR.swift
//  
//
//  Created by Maxim Volgin on 30/06/2021.
//

import Foundation

@available(macOS 10, iOS 13, *)
public extension Bundle {
    
    func demandResources(withTags tags: Set<String>) -> ODRPublisher {
        return ODRPublisher(tags: tags,bundle: self)
    }
    
}
