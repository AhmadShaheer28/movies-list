//
//  SearchViewController.swift
//  MovieListAssignment
//
//  Created by Ahmad Shaheer on 11/03/2023.
//

import UIKit

class SearchViewController: BaseViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: - Variables
    
    var movies = [Movie]()
    private var page = 1
    private var searching = true
    private var searchedQueries = [String]()
    
    
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
        let nib_ = UINib(nibName: "QueryCollectionViewCell", bundle: nil)
        collectionView.register(nib_, forCellWithReuseIdentifier: "cell2")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(didChange(_:)), for: .editingChanged)
        
        searchedQueries = DBManager.shared.getAllQueries()
        collectionView.reloadData()
    }
    
    
    //MARK: - Actions
    
    @IBAction func searchBtnAction(_ sender: Any) {
        guard let text = searchTF.text else { return }
        
        if !text.isEmpty {
            DBManager.shared.addSearchedQuery(searchedQuery: text)
            filterMovies()
        }
    }
    
    
    //MARK: - Methods
    
    func filterMovies() {
        NetworkRequest.shared.post(with: Endpoint.searchMovie, page: page, query: searchTF.text ?? "") { (results: MainApi<[Movie]>?, error) in
            guard let results else {
                self.showError(message: error ?? "")
                return
            }
            
            self.movies = results.data
            self.page += 1
            
            self.searching = false
            self.collectionView.reloadData()
        }
    }
    
    @objc func didChange(_ textfield: UITextField) {
        guard let text = textfield.text?.trimmingCharacters(in: .whitespaces) else { return }
        if text.isEmpty {
            if !movies.isEmpty {
                searching = false
                collectionView.reloadData()
            }
            return
        }
        
        let quries = DBManager.shared.getAllQueries()
        
        searchedQueries = quries.filter({ $0.range(of: text, options: .caseInsensitive) != nil })
        searching = true
        collectionView.reloadData()
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

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searching ? searchedQueries.count : movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if searching {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as? QueryCollectionViewCell else { return UICollectionViewCell() }
            cell.queryLbl.text = searchedQueries[indexPath.row]
            return cell
        }
        
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
        if searching {
            return CGSize(width: collectionView.frame.width, height: 47)
        }
        
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

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if searching {
            filterMovies()
        } else {
            let vc = DetailViewController()
            vc.movie = movies[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}
