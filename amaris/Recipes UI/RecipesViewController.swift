//
//  RecipesViewController.swift
//  amaris
//
//  Created by santiago calvo on 25/06/23.
//

import Foundation
import UIKit

class RecipesViewController: UITableViewController, UITableViewDataSourcePrefetching {
    
    private var loader: RecipeLoader?
    private var imageLoader: RecipeImageDataLoader?
    private var dataModel = [Recipe]()
    
    private var tasks = [IndexPath: RecipeImageDataLoaderTask]()
    
    convenience init(loader: RecipeLoader, imageLoader: RecipeImageDataLoader) {
        self.init()
        self.loader = loader
        self.imageLoader = imageLoader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.prefetchDataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        tableView.register(RecipeCell.self, forCellReuseIdentifier: RecipeCell.identifier)
        load()
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        loader?.load { [weak self] result in
            
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
