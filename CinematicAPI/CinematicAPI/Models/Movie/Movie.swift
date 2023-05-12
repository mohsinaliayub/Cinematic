//
//  Movie.swift
//  CinematicAPI
//
//  Created by Mohsin Ali Ayub on 12.05.23.
//

import Foundation

public struct Movie: Decodable {
    let id: Int
    public let title: String
    public let overview: String
    let status: Status
    public let genres: [Genre]
    public let adult: Bool
    public let originalLanguage: String
    private let backdropPath: String
    private let posterPath: String
    private let releaseDateString: String
    public let runtimeInMinutes: Int
    public let rating: Double
    let credits: Credits
    
    public var backdropPathURL: URL? {
        URL(string: Constants.APIConstants.baseURLForImages + backdropPath)
    }
    
    public var posterPathURL: URL? {
        URL(string: Constants.APIConstants.baseURLForImages + posterPath)
    }
    
    public var runtimeInHours: String {
        let hours = runtimeInMinutes / 60
        let minutes = runtimeInMinutes % 60
        
        return "\(hours)h\(minutes)m"
    }
    
    public var releaseDate: Date {
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
        case rating = "vote_average"
        case id, title, overview, status, genres, adult, credits
    }
}
