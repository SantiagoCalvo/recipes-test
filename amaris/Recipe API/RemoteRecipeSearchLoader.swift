//
//  RemoteRecipeSearchLoader.swift
//  amaris
//
//  Created by santiago calvo on 25/06/23.
//

import Foundation

class RemoteRecipeSearchLoader: SearchLoader {
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = RecipeLoader.Result
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    func load(from url: URL, completion: @escaping (Result) -> Void) {
        client.get(from: url) {[weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(RemoteRecipeSearchLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try RecipeSearchItemsMapper.map(data, from: response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemoteRecipeItem {
    func toModels() -> [Recipe] {
        return map { Recipe(title: $0.title ?? "", image: $0.image ?? URL(string: "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930")!) }
    }
}

final class RecipeSearchItemsMapper {
    
    private struct Root: Decodable {
        let results: [RemoteRecipeItem]
    }
    
    private static var OK_200: Int {
        return 200
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteRecipeItem] {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteRecipeLoader.Error.invalidData
        }

        return root.results
    }

}
