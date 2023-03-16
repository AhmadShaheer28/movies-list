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
    
    private var coordinator: MainCoordinator?
    private var movieVM: MovieListVM?
    
    private var setLoaderVisibility: Bool = false {
        didSet {
            if setLoaderVisibility {
                loader.isHidden = false
                loader.startAnimating()
            } else {
                loader.isHidden = true
                loader.stopAnimating()
            }
        }
    }
    
    
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
        
        setLoaderVisibility = true
        movieVM = MovieListVM(self)
    }
    
    
    //MARK: - Actions
    
    @objc func searchBtnAction() {
//        self.performSegue(withIdentifier: "SearchVC", sender: nil)
        coordinator?.startSearchController()
    }
    
    @objc func favBtnAction() {
        coordinator?.startFavController()
    }
    
    //MARK: - Methods
    
    
}

//MARK: - View Model Delagates

extension MovieListViewController: MovieListView {
    
    func onSuccessResponse() {
        setLoaderVisibility = false
        collectionView.reloadData()
    }
    
    func didFailed(with error: String) {
        setLoaderVisibility = false
        self.showError(message: error)
    }
}


//MARK: - Collection view delegates

extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieVM?.movies.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        
        if let movieVM {
            cell.config(movie: movieVM.movies[indexPath.row])
            cell.favBtn.tag = indexPath.row
            cell.favTapped = { [weak self] index in
                guard let self = self else { return }
                self.movieVM?.toggleFavMovie(at: index)
                
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2) - 15, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let movieVM {
            if indexPath.row == movieVM.movies.count - 8 && movieVM.page <= movieVM.totalPages {
                setLoaderVisibility = true
                movieVM.getMovies()
            }
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
        if let movieVM {
            coordinator?.startDetailController(for: movieVM.movies[indexPath.row])
        }
    }
}

