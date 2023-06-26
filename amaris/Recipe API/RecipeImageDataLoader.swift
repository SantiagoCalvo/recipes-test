//
//  RecipeImageDataLoader.swift
//  amaris
//
//  Created by santiago calvo on 25/06/23.
//

import Foundation

protocol RecipeImageDataLoaderTask {
    func cancel()
}

protocol RecipeImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> RecipeImageDataLoaderTask
}
