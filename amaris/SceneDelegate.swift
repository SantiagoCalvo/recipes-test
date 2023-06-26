//
//  SceneDelegate.swift
//  amaris
//
//  Created by santiago calvo on 25/06/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let getRecipesURL = URL(string: "https://api.spoonacular.com/recipes/random?number=30&apiKey=3e0da0568b28455b9a2d9382e9314b7e")!
        
        let urlSessionHTTPClient = URLSessionHTTPClient(session: .shared)
        
        let recipeLoader = MainQueueDispatchDecorator(decoratee: RemoteRecipeLoader(url: getRecipesURL, client: urlSessionHTTPClient))
        
        let recipeImageLoader = MainQueueDispatchDecorator2(decoratee: RemoteRecipeImageDataLoader(client: urlSessionHTTPClient))
        
        let recipesViewController = RecipesViewController(loader: recipeLoader, imageLoader: recipeImageLoader)
        
        /// search viewController compostion
        let searchLoader = MainQueueDispatchDecorator3(decoratee: RemoteRecipeSearchLoader(client: urlSessionHTTPClient))
        let searchViewController = SearchRecipeViewController(loader: searchLoader, imageLoader: recipeImageLoader)
        let searchControllerNavigation = UINavigationController(rootViewController: searchViewController)
        
        let tabbarController = UITabBarController()
        
        recipesViewController.tabBarItem = UITabBarItem(title: "Home", image: nil, selectedImage: nil)
        searchControllerNavigation.tabBarItem = UITabBarItem(title: "Search", image: nil, selectedImage: nil)
        
        tabbarController.viewControllers = [recipesViewController, searchControllerNavigation]
        tabbarController.selectedViewController = recipesViewController
        
        window.rootViewController = tabbarController
        window.makeKeyAndVisible()
        self.window = window
    }

}
