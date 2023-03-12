//
//  ApiModel.swift
//  MovieListAssignment
//
//  Created by Ahmad Shaheer on 10/03/2023.
//

import Foundation


struct MainApi<T: Codable>: Codable {
    let page: Int
    let data: T!
    let totalPages: Int
    let totalResults: Int
    
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decode(Int.self, forKey: .page)
        data = try values.decode(T.self, forKey: .data)
        totalPages = try values.decode(Int.self, forKey: .totalPages)
        totalResults = try values.decode(Int.self, forKey: .totalResults)
    }
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case data = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.page, forKey: .page)
        try container.encode(self.data, forKey: .data)
        try container.encode(self.totalPages, forKey: .totalPages)
        try container.encode(self.totalResults, forKey: .totalResults)
    }
}


struct Movie: Codable {
    let adult: Bool
    let backdropPath : String
    let genreIds : [Int]
    let id : Int
    let originalLanguage : String
    let originalTitle : String
    let overview : String
    let popularity : Double
    let posterPath : String
    let releaseDate : String
    let title : String
    let video : Bool
    let voteAverage : Double
    let voteCount : Int

    
    enum CodingKeys: String, CodingKey {
        
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id = "id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview = "overview"
        case popularity = "popularity"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title = "title"
        case video = "video"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
