//
//  MovieService.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 24.04.23.
//

import Foundation

protocol MovieFetcher {
    /// The URL holder for TMDB API.
    var cinematicURL: CinematicURL? { get set}
    
    /// The API returns results in pages. Keeps track of the next page to query.
    var trendingNowPageToQueryNext: Int? { get set }
    
    /// Fetch trending weekly movies from TMDB API.
    func fetchTrendingMovies() async throws -> [MediaSummary]
}

class CinematicMovieService: MovieFetcher {
    
    public var trendingMovies: [MediaSummary]
    
    var trendingNowPageToQueryNext: Int?
    var cinematicURL: CinematicURL?
    
    init() {
        trendingMovies = []
    }
    
    func fetchTrendingMovies() async throws -> [MediaSummary] {
        cinematicURL = .trending(mediaType: .movie, page: trendingNowPageToQueryNext)
        
        // Get url for trending movies otherwise throw url error.
        guard let url = cinematicURL?.url else {
            throw NetworkRequestError.urlError
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let networkError = NetworkRequestError.networkError(from: response as? HTTPURLResponse) {
            throw networkError
        }
        
        let mediaResult = try JSONDecoder().decode(MediaResult.self, from: data)
        trendingNowPageToQueryNext = mediaResult.page + 1 // move on to next page for query
        
        trendingMovies = mediaResult.results
        
        return trendingMovies
    }
}
