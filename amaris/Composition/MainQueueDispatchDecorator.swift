//
//  MainQueueDispatchDecorator.swift
//  amaris
//
//  Created by santiago calvo on 25/06/23.
//

import Foundation

final class MainQueueDispatchDecorator: RecipeLoader {

    private let decoratee: RecipeLoader

    init(decoratee: RecipeLoader) {
        self.decoratee = decoratee
    }

    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }

        completion()
    }
    
    func load(completion: @escaping (RecipeLoader.Result) -> Void) {
                decoratee.load { [weak self] result in
                    self?.dispatch {
                        completion(result)
                    }
                }
    }

}

final class MainQueueDispatchDecorator2: RecipeImageDataLoader {
    

    private let decoratee: RecipeImageDataLoader

    init(decoratee: RecipeImageDataLoader) {
        self.decoratee = decoratee
    }

    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }

        completion()
    }
    
    func loadImageData(from url: URL, completion: @escaping (RecipeImageDataLoader.Result) -> Void) -> RecipeImageDataLoaderTask {
                decoratee.loadImageData(from: url) { [weak self] result in
                    self?.dispatch {
                        completion(result)
                    }
                }
    }

}

class MainQueueDispatchDecorator3: SearchLoader {
    
    private let decoratee: SearchLoader

    init(decoratee: SearchLoader) {
        self.decoratee = decoratee
    }

    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }

        completion()
    }
    
    func load(from url: URL, completion: @escaping (SearchLoader.Result) -> Void) {
        decoratee.load(from: url) { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}
