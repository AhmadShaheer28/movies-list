//
//  FavMovieViewController.swift
//  MovieListAssignment
//
//  Created by Ahmad Shaheer on 12/03/2023.
//

import UIKit

class FavMovieViewController: BaseViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: - Variables
    
    private var movies = [Movie]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    //MARK: - View Setup
    func setupView() {
        title = "Favorite Movies"
        
        let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        movies = DBManager.shared.getAllFavMovies()
        collectionView.reloadData()
    }
    
    
    //MARK: - Actions
    
    
    
    //MARK: - Methods
    
    func toggleFavMovie(at index: Int) {
        let movieAtIndex = movies[index]
        if DBManager.shared.isFavMovie(movie: movieAtIndex) {
            print(movieAtIndex.id)
            DBManager.shared.deleteFavMovie(movie: movieAtIndex)
        } else {
            DBManager.shared.saveFavMovie(movie: movieAtIndex)
        }
        
        collectionView.reloadData()
    }
    
}


extension FavMovieViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        
        cell.config(movie: movies[indexPath.row])
        cell.favBtn.tag = indexPath.row
        cell.favTapped = { [weak self] index in
            guard let self = self else { return }
            self.toggleFavMovie(at: index)
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2) - 15, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    // inavalidates layout when device's orientation is changed
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateCollectionViewLayout(with: size)
    }

    private func updateCollectionViewLayout(with size: CGSize) {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: (collectionView.frame.width / 2) - 15, height: 180)
            layout.invalidateLayout()
        }
    }
}


extension FavMovieViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.movie = movies[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
