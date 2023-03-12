//
//  MovieListViewController.swift
//  MovieListAssignment
//
//  Created by Ahmad Shaheer on 10/03/2023.
//

import UIKit

class MovieListViewController: BaseViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: - Variables
    
    private var movies = [Movie]()
    private var page = 1
    private var totalPages = 0
    var coordinator: MainCoordinator?
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navController = self.navigationController {
            coordinator = MainCoordinator(navigationController: navController)
        }
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    
    //MARK: - View Setup
    func setupView() {
        title = "Movies"
        
        let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        let favImg = UIImage(named: "not.fav")
        let searchBtn = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBtnAction))
        let favBtn = UIBarButtonItem(image: favImg, style: .plain, target: self, action: #selector(favBtnAction))
        
        navigationItem.rightBarButtonItems = [searchBtn, favBtn]
        
        getMovies(for: page)
    }
    
    
    //MARK: - Actions
    
    @objc func searchBtnAction() {
        self.performSegue(withIdentifier: "SearchVC", sender: nil)
    }
    
    @objc func favBtnAction() {
        coordinator?.startFavController()
    }
    
    //MARK: - Methods
    
    func getMovies(for page: Int) {
        loader.isHidden = false
        loader.startAnimating()
        
        NetworkRequest.shared.post(with: Endpoint.movieList, page: page) { (results: MainApi<[Movie]>?, error) in
            self.loader.isHidden = true
            self.loader.stopAnimating()
            
            guard let results else {
                self.showError(message: error ?? "")
                return
            }
            
            self.movies.append(contentsOf: results.data)
            self.page += 1
            self.totalPages = results.totalPages
            self.collectionView.reloadData()
            
        }
    }
    
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

//MARK: - Collection view delegates

extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 8 && page <= totalPages {
            getMovies(for: page)
        }
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


extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.startDetailController(for: movies[indexPath.row])
    }
}
