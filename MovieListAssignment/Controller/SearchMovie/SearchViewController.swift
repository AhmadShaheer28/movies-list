//
//  SearchViewController.swift
//  MovieListAssignment
//
//  Created by Ahmad Shaheer on 11/03/2023.
//

import UIKit

class SearchViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: - Variables
    
    var movies = [Movie]()
    private var page = 1
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    //MARK: - View Setup
    func setupView() {
        title = "Search"
        let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
    }
    
    
    //MARK: - Actions
    
    @IBAction func searchBtnAction(_ sender: Any) {
        
    }
    
    
    //MARK: - Methods
    
    func getMovies(for page: Int) {
//        NetworkRequest.shared.post(page: page) { (results: MainApi<[Movie]>?, error) in
//            guard let results else { return }
//            
//            self.movies = results.data
//            self.page += 1
//            
//            self.collectionView.reloadData()
//        }
    }
    
    
}

//MARK: - Collection view delegates

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        
//        cell.config(movie: movies[indexPath.row])
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
