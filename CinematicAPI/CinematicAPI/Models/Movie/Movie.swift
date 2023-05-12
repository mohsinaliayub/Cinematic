//
//  Movie.swift
//  CinematicAPI
//
//  Created by Mohsin Ali Ayub on 12.05.23.
//

import Foundation

public struct Movie: Decodable {
    let id: Int
    let title: String
    let overview: String
    let status: Status
    let genres: [Genre]
    let adult: Bool
    let originalLanguage: String
    private let backdropPath: String
    private let posterPath: String
    let releaseDateString: String
    let runtimeInMinutes: Int
    let credits: Credits
    
    var backdropPathURL: URL? {
        URL(string: Constants.APIConstants.baseURLForImages + backdropPath)
    }
    
    var posterPathURL: URL? {
        URL(string: Constants.APIConstants.baseURLForImages + posterPath)
    }
    
    var releaseDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en-US")
        
        return dateFormatter.date(from: releaseDateString)!
    }
    
    enum CodingKeys: String, CodingKey {
        case originalLanguage = "original_language"
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case releaseDateString = "release_date"
        case runtimeInMinutes = "runtime"
        case id, title, overview, status, genres, adult, credits
    }
}
