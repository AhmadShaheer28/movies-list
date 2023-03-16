//
//  MovieListVM.swift
//  MovieListAssignment
//
//  Created by Ahmad Shaheer on 16/03/2023.
//

import Foundation


protocol MovieListView: NSObject {
    func onSuccessResponse()
    func didFailed(with error: String)
}

class MovieListVM {
    weak var delegate: MovieListView?
    var movies = [Movie]()
    var page = 1
    var totalPages = 0
    
    
    init(_ delegate: MovieListView? ) {
        self.delegate = delegate
        getMovies()
    }
    
    func getMovies() {
        
        NetworkRequest.shared.post(with: Endpoint.movieList, page: page) { (results: MainApi<[Movie]>?, error) in
            
            guard let results else {
                if let error {
                    self.delegate?.didFailed(with: error)
                }
                return
            }
            
            self.page += 1
            self.totalPages = results.totalPages
            self.movies.append(contentsOf: results.data)
            self.delegate?.onSuccessResponse()
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
        
        delegate?.onSuccessResponse()
    }
}
