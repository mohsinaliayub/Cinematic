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
    
    /// Fetch weekly trending media type from TMDB API.
    func fetchTrending(mediaType: MediaType, fromPage: Int?) async throws -> (pageToQueryNext: Int?, medias: [MediaSummary])
    
    /// Fetch movie details from TMDB API.
    func fetchMovieDetails(for: MediaType, by: MovieID) async throws -> Movie
}

class CinematicMovieService: MovieFetcher {
    typealias MovieID = String
    
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
    
    func fetchTrending(mediaType: MediaType, fromPage pageToQueryNext: Int?) async throws -> (pageToQueryNext: Int?, medias: [MediaSummary]) {
        cinematicURL = .trending(mediaType: mediaType, page: pageToQueryNext)
        
        // Get url or throw url error.
        guard let url = cinematicURL?.url else {
            throw NetworkRequestError.urlError
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        _ = try responseIsSuccessful(response)
        
        let mediaResult = try JSONDecoder().decode(MediaResult.self, from: data)
        
        return (mediaResult.page + 1, mediaResult.results)
    }
    
    func fetchMovieDetails(for mediaType: MediaType, by id: Int) async throws -> Movie {
        cinematicURL = .detail(for: mediaType, id: id)
        
        let url = try url(cinematicURL?.url)
        let (data, response) = try await URLSession.shared.data(from: url)
        _ = try responseIsSuccessful(response)
        
        let movie = try JSONDecoder().decode(Movie.self, from: data)
        return movie
    }
    
    private func url(_ url: URL?) throws -> URL {
        guard let url = url else { throw NetworkRequestError.urlError }
        return url
    }
    
    private func responseIsSuccessful(_ urlResponse: URLResponse) throws -> Bool {
        if let networkError = NetworkRequestError.networkError(from: urlResponse as? HTTPURLResponse) {
            throw networkError
        }
        
        return true
    }
}
