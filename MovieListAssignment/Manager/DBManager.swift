//
//  DBManager.swift
//  MovieListAssignment
//
//  Created by Ahmad Shaheer on 12/03/2023.
//

import Foundation
import CoreData
import UIKit

class DBManager: NSObject {
    
    private let delegate = UIApplication.shared.delegate as! AppDelegate
    private let context: NSManagedObjectContext
    
    static let shared = DBManager()
    
    
    private override init() {
        context = delegate.persistentContainer.viewContext
    }
    
    func saveFavMovie(movie: Movie) {
        guard let favMovie = NSEntityDescription.entity(forEntityName: "FavMovies", in: context) else { return }
        
        let fav = NSManagedObject(entity: favMovie, insertInto: context)
        
        fav.setValue("\(movie.id)", forKey: "uid")
        fav.setValue(movie.title, forKey: "title")
        fav.setValue(movie.originalTitle, forKey: "originalTitle")
        fav.setValue(movie.posterPath, forKey: "posterPath")
        fav.setValue(movie.releaseDate, forKey: "releaseDate")
        fav.setValue(movie.overview, forKey: "overView")
        
        do { try context.save() }
        catch let error { print("error while saving Data", error.localizedDescription) }
    }
    
    func deleteFavMovie(movie: Movie) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavMovies")
        fetchRequest.predicate = NSPredicate(format: "uid == %@", "\(movie.id)")
        
        do {
            if let results = try context.fetch(fetchRequest) as? [FavMovies] {
                
                if let res = results.first {
                    context.delete(res)
                }
                
            } else {
                // Error deleting data
            }
        } catch let error {
            print("Fav error", error.localizedDescription)
        }
    }
    
    func isFavMovie(movie: Movie) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavMovies")
        fetchRequest.predicate = NSPredicate(format: "uid == %@", "\(movie.id)")
        
        do {
            if let results = try context.fetch(fetchRequest) as? [FavMovies] {
                if results.count > 0 {
                    return true
                }
            }
        } catch let error {
            print("Fav error", error.localizedDescription)
        }
        
        return false
    }
    
    func getAllFavMovies() -> [Movie] {
        
        var favMovies = [Movie]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavMovies")
        
        do {
            guard let data = try context.fetch(fetchRequest) as? [FavMovies] else { return [] }
            
            for mov in data {
                if let id = mov.uid, let title = mov.title, let originalTitle = mov.originalTitle, let posterUrl = mov.posterPath, let releaseDate = mov.releaseDate, let overview = mov.overView {
                    favMovies.append(Movie(adult: false, backdropPath: "", genreIds: [], id: Int(id) ?? 0, originalLanguage: "", originalTitle: originalTitle, overview: overview, popularity: 0, posterPath: posterUrl, releaseDate: releaseDate, title: title, video: false, voteAverage: 0, voteCount: 0))
                }
            }
            
            return favMovies
            
        } catch let error {
            print("Fav error", error.localizedDescription)
        }
        
        return []
    }
}
