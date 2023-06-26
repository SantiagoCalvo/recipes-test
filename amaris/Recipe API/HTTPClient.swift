//
//  HTTPClient.swift
//  amaris
//
//  Created by santiago calvo on 25/06/23.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    /// The Completion Handler Can be Invoke in any thread
    /// Clients are responsible to dispatch to appropiate threads if needed
    @discardableResult
    func get(from url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
