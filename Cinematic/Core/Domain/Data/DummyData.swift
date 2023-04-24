//
//  DummyData.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 10.02.23.
//

import Foundation

struct DummyData {
    private static let glassOnionBackdropURL =
        URL(string: Constants.APIConstants.baseURLForImages + "/dKqa850uvbNSCaQCV4Im1XlzEtQ.jpg")
    private static let glassOnionPosterURL =
        URL(string: Constants.APIConstants.baseURLForImages + "/vDGr1YdrlfbU9wxTOdpf3zChmv9.jpg")
    
    static var glassOnionMediaSummary: MediaSummary {
        MediaSummary(id: 661374, title: "Glass Onion: A Knives Out Mystery", name: nil,
                     backdropURL: glassOnionBackdropURL, posterURL: glassOnionPosterURL,
                     mediaType: .movie)
    }
    
    private static let genres: [Genre] = [
        Genre(id: 35, name: "Comedy"),
        Genre(id: 80, name: "Crime"),
        Genre(id: 9648, name: "Mystery")
    ]
    static var glassOnionMovie: Movie {
        Movie(id: 661374, title: "Glass Onion: A Knives Out Mystery", overview: "World-famous detective Benoit Blanc heads to Greece to peel back the layers of a mystery surrounding a tech billionaire and his eclectic crew of friends.", status: .released, genres: genres, adult: false, originalLanguage: "en", backdropPath: "/dKqa850uvbNSCaQCV4Im1XlzEtQ.jpg", posterPath: "/vDGr1YdrlfbU9wxTOdpf3zChmv9.jpg", releaseDateString: "2022-11-23", runtimeInMinutes: 140)
    }
}
