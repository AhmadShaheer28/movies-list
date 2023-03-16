//
//  SearchCoordinator.swift
//  MovieListAssignment
//
//  Created by Ahmad Shaheer on 16/03/2023.
//

import UIKit


class SearchCoordinator: NSObject, Coordinator {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    func startSearchController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController {
            vc.coordinator = self
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func startDetailController(for movie: Movie) {
        let vc = DetailViewController()
        vc.movie = movie
        navigationController.pushViewController(vc, animated: true)
    }
}
