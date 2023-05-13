//
//  MovieService.swift
//  CinematicAPI
//
//  Created by Mohsin Ali Ayub on 12.05.23.
//

import Foundation

public protocol MovieFetcher {
    typealias MediaWithPageToQuery = (pageToQueryNext: Int?, mediaSummaries: [MediaSummary])
    
    /// The URL holder for TMDB API.
    var cinematicURL: CinematicURL? { get set}
    
    /// Fetch weekly trending media type from TMDB API.
    func fetchTrending(mediaType: MediaType, fromPage: Int?) async throws -> MediaWithPageToQuery
    
    /// Fetch movie details from TMDB API.
    func fetchMovieDetails(for: MediaType, by: MovieID) async throws -> Movie
    
    /// Fetch popular movies from TMDB API.
    func fetchPopularMovies() async throws -> [MediaSummary]
    
    func fetchUpcomingMovies() async throws -> [MediaSummary]
    
    func fetchRecommendations(for: MovieID) async throws -> [MediaSummary]
}

public class CinematicMovieService: MovieFetcher {
    public var cinematicURL: CinematicURL?
    
    public init() {
        
    }
    
    public func fetchTrending(mediaType: MediaType, fromPage pageToQueryNext: Int?) async throws -> MediaWithPageToQuery {
        cinematicURL = .trending(mediaType: mediaType, page: pageToQueryNext)
        
        let mediaWithPageToQuery = try await fetchMediaResult(from: cinematicURL?.url)
        return mediaWithPageToQuery
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
        
        let mediaWithPageToQuery = try await fetchMediaResult(from: cinematicURL?.url)
        return mediaWithPageToQuery.mediaSummaries
    }
    
    public func fetchUpcomingMovies() async throws -> [MediaSummary] {
        cinematicURL = .upcomingMovies
        
        let mediaWithPageToQuery = try await fetchMediaResult(from: cinematicURL?.url)
        return mediaWithPageToQuery.mediaSummaries
    }
    
    public func fetchRecommendations(for id: MovieID) async throws -> [MediaSummary] {
        cinematicURL = .movieRecommendations(for: id)
        
        let (_, mediaSummaries) = try await fetchMediaResult(from: cinematicURL?.url)
        return mediaSummaries
    }
    
    private func fetchMediaResult(from url: URL?) async throws -> MediaWithPageToQuery {
        // Get url or throw url error.
        guard let url = url else { throw NetworkRequestError.urlError }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        _ = try responseIsSuccessful(response)
        
        let mediaResult = try JSONDecoder().decode(MediaResult.self, from: data)
        return (mediaResult.page + 1, mediaResult.results)
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
