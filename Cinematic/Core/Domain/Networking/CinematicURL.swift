//
//  CinematicURL.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 24.04.23.
//

import Foundation

/// Represents a unique movie id.
typealias MovieID = Int

enum MovieResultType {
    case popular, details
}

enum CinematicURL {
    case trending(mediaType: MediaType, page: Int?)
    case movie(id: MovieID)
    
    var url: URL? {
        switch self {
        case .trending(let mediaType, let page):
            var components = url(with: "/trending/\(mediaType.rawValue)/week")
            
            if let page = page {
                components?.addQueryItem(withName: "page", andValue: "\(page)")
            }
            
            return components?.url
        case .movie(let id):
            return url(with: "/movie/\(id)")?.url
        }
    }
    
    private func url(with string: String) -> URLComponents? {
        var components = URLComponents(string: Constants.APIConstants.baseURL + string)
        components?.setQueryItems(with: ["api_key": Constants.APIConstants.apiKey])
        
        return components
    }
}
