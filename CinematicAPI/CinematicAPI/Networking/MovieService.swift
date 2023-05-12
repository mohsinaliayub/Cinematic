//
//  MovieService.swift
//  CinematicAPI
//
//  Created by Mohsin Ali Ayub on 12.05.23.
//

import Foundation

public protocol MovieFetcher {
    
    /// The URL holder for TMDB API.
    var cinematicURL: CinematicURL? { get set}
    
    /// Fetch weekly trending media type from TMDB API.
    func fetchTrending(mediaType: MediaType, fromPage: Int?) async throws -> (pageToQueryNext: Int?, medias: [MediaSummary])
    
    /// Fetch movie details from TMDB API.
    func fetchMovieDetails(for: MediaType, by: MovieID) async throws -> Movie
    
    /// Fetch popular movies from TMDB API.
    func fetchPopularMovies() async throws -> [MediaSummary]
    
    func fetchUpcomingMovies() async throws -> [MediaSummary]
}

public class CinematicMovieService: MovieFetcher {
    typealias MovieID = String
    
    public var trendingMovies: [MediaSummary]
    
    public var cinematicURL: CinematicURL?
    
    public init() {
        trendingMovies = []
    }
    
    public func fetchTrending(mediaType: MediaType, fromPage pageToQueryNext: Int?) async throws -> (pageToQueryNext: Int?, medias: [MediaSummary]) {
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
    
    public func fetchMovieDetails(for mediaType: MediaType, by id: Int) async throws -> Movie {
        cinematicURL = .detail(for: mediaType, id: id)
        
        let url = try url(cinematicURL?.url)
        let (data, response) = try await URLSession.shared.data(from: url)
        _ = try responseIsSuccessful(response)
        
        let movie = try JSONDecoder().decode(Movie.self, from: data)
        return movie
    }
    
    public func fetchPopularMovies() async throws -> [MediaSummary] {
        cinematicURL = .popular
        
        // Get url or throw url error.
        guard let url = cinematicURL?.url else {
            throw NetworkRequestError.urlError
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        _ = try responseIsSuccessful(response)
        
        let mediaResult = try JSONDecoder().decode(MediaResult.self, from: data)
        
        return mediaResult.results
    }
    
    public func fetchUpcomingMovies() async throws -> [MediaSummary] {
        cinematicURL = .upcomingMovies
        
        // Get url or throw url error.
        guard let url = cinematicURL?.url else {
            throw NetworkRequestError.urlError
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        _ = try responseIsSuccessful(response)
        
        let mediaResult = try JSONDecoder().decode(MediaResult.self, from: data)
        
        return mediaResult.results
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
