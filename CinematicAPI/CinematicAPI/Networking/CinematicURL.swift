//
//  CinematicURL.swift
//  CinematicAPI
//
//  Created by Mohsin Ali Ayub on 12.05.23.
//

import Foundation

/// Represents a unique movie id.
public typealias MovieID = Int

public enum CinematicURL {
    case trending(mediaType: MediaType, page: Int?)
    case detail(for: MediaType, id: MovieID)
    case popular
    case genre(for: MediaType)
    case upcomingMovies
    case movieRecommendations(for: MovieID)
    
    var url: URL? {
        switch self {
        case .trending(let mediaType, let page):
            var components = url(with: "/trending/\(mediaType.rawValue)/week")
            
            if let page = page {
                components?.addQueryItem(withName: "page", andValue: "\(page)")
            }
            
            return components?.url
        case .detail(let mediaType, let id):
            var components = url(with: "/\(mediaType.rawValue)/\(id)")
            components?.addQueryItem(withName: "append_to_response", andValue: "credits")
            
            return components?.url
            
        case .popular:
            return url(with: "/movie/popular")?.url
            
        case .genre(let mediaType):
            return url(with: "/genre/\(mediaType)/list")?.url
            
        case .upcomingMovies:
            return url(with: "/movie/upcoming")?.url
            
        case .movieRecommendations(let id):
            return url(with: "/movie/\(id)/recommendations")?.url
            
        }
    }
    
    private func url(with string: String) -> URLComponents? {
        var components = URLComponents(string: Constants.APIConstants.baseURL + string)
        components?.setQueryItems(with: ["api_key": Constants.APIConstants.apiKey])
        
        return components
    }
}
