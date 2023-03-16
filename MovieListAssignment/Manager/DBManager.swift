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
    
    private let delegate = UIApplication.shared.delegate as? AppDelegate
    private let context: NSManagedObjectContext?
    
    static let shared = DBManager()
    
    
    private override init() {
        context = delegate?.persistentContainer.viewContext
    }
    
    func saveFavMovie(movie: Movie) {
        guard let context else { return }
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
        guard let context else { return }
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
        
        delegate?.saveContext()
    }
    
    func isFavMovie(movie: Movie) -> Bool {
        guard let context else { return false }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavMovies")
        fetchRequest.predicate = NSPredicate(format: "uid == %@", "\(movie.id)")
        
        do {
            if let results = try context.fetch(fetchRequest) as? [FavMovies] {
                if results.count > 0 {
                    print(results.first?.title ?? "")
                    return true
                }
            }
        } catch let error {
            print("Fav error", error.localizedDescription)
        }
        
        return false
    }
    
    func getAllFavMovies() -> [Movie] {
        guard let context else { return [] }
        var favMovies = [Movie]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavMovies")
        
        do {
            guard let data = try context.fetch(fetchRequest) as? [FavMovies] else { return [] }
            
            for mov in data {
                if let id = mov.uid, let title = mov.title, let originalTitle = mov.originalTitle, let posterUrl = mov.posterPath, let releaseDate = mov.releaseDate, let overview = mov.overView {
                    favMovies.append(Movie(adult: false, backdropPath: "", genreIds: [], id: UInt(id) ?? 0, originalLanguage: "", originalTitle: originalTitle, overview: overview, popularity: 0, posterPath: posterUrl, releaseDate: releaseDate, title: title, video: false, voteAverage: 0, voteCount: 0))
                }
            }
            
            return favMovies
            
        } catch let error {
            print("Fav error", error.localizedDescription)
        }
        
        return []
    }
    
    func addSearchedQuery(searchedQuery: String) {
        guard let context else { return }
        guard let queries = NSEntityDescription.entity(forEntityName: "SearchQuery", in: context) else { return }
        
        let query = NSManagedObject(entity: queries, insertInto: context)
        
        let allQueries = getAllQueries()
        
        if !allQueries.contains(where: { $0 == searchedQuery }) {
            query.setValue(searchedQuery, forKey: "query")
            
            do { try context.save() }
            catch let error { print("error while saving Data", error.localizedDescription) }
        }
    }
    
    func getAllQueries() -> [String] {
        
        guard let context else { return [] }
        
        var queries = [String]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchQuery")
        
        do {
            guard let data = try context.fetch(fetchRequest) as? [SearchQuery] else { return [] }
            
            for q in data {
                if let val = q.query {
                    queries.append(val)
                }
            }
            
            return queries
            
        } catch let error {
            print("Fav error", error.localizedDescription)
        }
        
        return []
    }
}
