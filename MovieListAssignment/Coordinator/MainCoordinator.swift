//
//  MainCoordinator.swift
//  MovieListAssignment
//
//  Created by Ahmad Shaheer on 12/03/2023.
//

import UIKit

protocol Coordinator: NSObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
}


class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    func startSearchController() {
        let coordinator = SearchCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.startSearchController()
    }
    
    func startFavController() {
        let vc = FavMovieViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func startDetailController(for movie: Movie) {
        let vc = DetailViewController()
        vc.movie = movie
        navigationController.pushViewController(vc, animated: true)
    }
    
}
