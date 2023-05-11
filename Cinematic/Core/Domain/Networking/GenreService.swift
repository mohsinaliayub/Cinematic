//
//  GenreService.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 11.05.23.
//

import Foundation

class GenreService {
    static let shared: GenreService = GenreService()
    
    private var cinematicURL: CinematicURL?
    private var movieGenres: [Genre]
    private var tvGenres: [Genre]
    
    init() {
        movieGenres = []; tvGenres = []
    }
    
    func genresByIds(_ ids: [Int], for mediaType: MediaType) async throws -> [Genre] {
        let genres = try await fetchGenres(for: mediaType)
        
        return genres.filter { ids.contains($0.id) }
    }
    
    func fetchGenres() async throws {
        async let movieGenresRequest = try await fetchGenres(for: .movie)
        async let tvGenresRequest = try await fetchGenres(for: .tv)
        
        let (movieGenres, tvGenres) = try await (movieGenresRequest, tvGenresRequest)
        self.movieGenres = movieGenres
        self.tvGenres = tvGenres
    }
    
    private func fetchGenres(for mediaType: MediaType) async throws -> [Genre] {
        // if there are no genres already, fetch from the API
        guard genres(for: mediaType).isEmpty else {
            return genres(for: mediaType)
        }
        
        cinematicURL = .genre(for: mediaType)
        guard let url = cinematicURL?.url else {
            throw NetworkRequestError.urlError
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        _ = try responseIsSuccessful(response)
        
        let genreResult = try JSONDecoder().decode(GenreResult.self, from: data)
        return genreResult.genres
    }
    
    private func genres(for mediaType: MediaType) -> [Genre] {
        switch mediaType {
        case .movie:
            return movieGenres
        case .tv:
            return tvGenres
        }
    }
    
    private func responseIsSuccessful(_ urlResponse: URLResponse) throws -> Bool {
        if let networkError = NetworkRequestError.networkError(from: urlResponse as? HTTPURLResponse) {
            throw networkError
        }
        
        return true
    }
}
