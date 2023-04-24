//
//  TV.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 10.02.23.
//

import Foundation

struct TV: Identifiable {
    let id: Int
    let name: String
    let overview: String
    let status: Status
    let genres: [Genre]
    let backdropPath: String
    let posterPath: String
    let releaseDateString: String
    let adult: Bool
    
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
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case releaseDateString = "release_date"
        case id, name, overview, status, genres, adult
    }
}
