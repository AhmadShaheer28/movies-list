//
//  NetworkRequest.swift
//  MovieListAssignment
//
//  Created by Ahmad Shaheer on 11/03/2023.
//

import Foundation



struct ApiRequest {
    static let baseUrl = "https://api.themoviedb.org/3/"
    static let posterUrl = "https://image.tmdb.org/t/p/w92"
    
    static let apiKey = "e5ea3092880f4f3c25fbc537e9b37dc1"
    
}

struct Endpoint {
    static let movieList = ApiRequest.baseUrl + "movie/popular"
    static let searchMovie = ApiRequest.baseUrl + "search/movie"
}


class NetworkRequest {
    static let shared = NetworkRequest()
    
    func post<T: Decodable>(with url: String, page: Int, query: String = "", completion: @escaping (T?, String?) -> Void) {
        
        var componenet = URLComponents(string: url)!
        
        componenet.queryItems = [
            URLQueryItem(name: "api_key", value: ApiRequest.apiKey),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        if !query.isEmpty {
            componenet.queryItems?.append(URLQueryItem(name: "query", value: query))
        }
                                       
        var request = URLRequest(url: componenet.url!)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                print("json is downloaded")
                
                if let error = error {
                    completion(nil, error.localizedDescription) ; return
                }
                
                guard let data = data else { completion(nil, "Unable to get the data") ; return }
                print("json =>", String(data: data, encoding: .utf8) ?? "no json")
                do {
                    completion(try JSONDecoder().decode(T.self, from: data), nil)
                } catch let error {
                    completion(nil, error.localizedDescription)
                }
            }
            
        }.resume()
        
    }
}
