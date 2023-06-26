//
//  RecipeLoader.swift
//  amaris
//
//  Created by santiago calvo on 25/06/23.
//

import Foundation

protocol RecipeLoader {
    typealias Result = Swift.Result<[Recipe], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
