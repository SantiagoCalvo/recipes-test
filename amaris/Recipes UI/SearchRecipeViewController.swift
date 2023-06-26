//
//  SearchRecipeViewController.swift
//  amaris
//
//  Created by santiago calvo on 25/06/23.
//

import UIKit

protocol SearchLoader {
    typealias Result = Swift.Result<[Recipe], Error>
    func load(from url: URL, completion: @escaping (Result) -> Void)
}

class SearchRecipeViewController: UITableViewController, UITableViewDataSourcePrefetching {
    
    private var loader: SearchLoader?
    private var imageLoader: RecipeImageDataLoader?
    private var dataModel = [Recipe]()
    var urlComps = URLComponents(string: "https://api.spoonacular.com/recipes/complexSearch")!
    
    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.translatesAutoresizingMaskIntoConstraints = false
        search.obscuresBackgroundDuringPresentation = false
        return search
    }()
    
    private var tasks = [IndexPath: RecipeImageDataLoaderTask]()
    
    convenience init(loader: SearchLoader, imageLoader: RecipeImageDataLoader) {
        self.init()
        self.loader = loader
        self.imageLoader = imageLoader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        tableView.prefetchDataSource = self
        
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
        tableView.register(RecipeCell.self, forCellReuseIdentifier: RecipeCell.identifier)
        
    }
    
    private func load(with url: URL) {
        refreshControl?.beginRefreshing()
        loader?.load(from: url) { [weak self] result in
            
            switch result {
            case let .success(recipes):
                self?.dataModel = recipes
                self?.tableView.reloadData()
            case let .failure(error):
                self?.showErrorMessage(error)
            }
            
            self?.refreshControl?.endRefreshing()
        }
    }
    
    private func showErrorMessage(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = dataModel[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCell.identifier, for: indexPath) as! RecipeCell
        cell.titleLabel.text = cellModel.title
        cell.recipeImageView.image = nil
        
        cell.backgroundImageView.isShimmering = true
        tasks[indexPath] = imageLoader?.loadImageData(from: cellModel.image) { [weak cell] result in
            
            let data = try? result.get()
            cell?.recipeImageView.image = data.map(UIImage.init) ?? nil
            
            cell?.backgroundImageView.isShimmering = false
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tasks[indexPath]?.cancel()
        tasks[indexPath] = nil
        let cell = cell as? RecipeCell
        cell?.titleLabel.text = nil
        cell?.recipeImageView.image = nil
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let cellModel = dataModel[indexPath.row]
            tasks[indexPath] = imageLoader?.loadImageData(from: cellModel.image, completion: { _ in })
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            tasks[indexPath]?.cancel()
            tasks[indexPath] = nil
        }
    }
    
}

extension SearchRecipeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        let queryItems = [URLQueryItem(name: "apiKey", value: "3e0da0568b28455b9a2d9382e9314b7e"), URLQueryItem(name: "query", value: text)]
        urlComps.queryItems = queryItems
        if let url = urlComps.url {
            self.load(with: url)
        }
    }
}
