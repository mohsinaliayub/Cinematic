//
//  CinematicURL.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 24.04.23.
//

import Foundation

enum MovieResultType {
    case popular, details
}

enum CinematicURL {
    case trending(mediaType: MediaType, page: Int?)
    
    var url: URL? {
        switch self {
        case .trending(let mediaType, let page):
            var components = url(with: "/trending/\(mediaType.rawValue)/week")
            
            if let page = page {
                components?.addQueryItem(withName: "page", andValue: "\(page)")
            }
            
            return components?.url
        }
    }
    
    private func url(with string: String) -> URLComponents? {
        var components = URLComponents(string: Constants.APIConstants.baseURL + string)
        components?.setQueryItems(with: ["api_key": Constants.APIConstants.apiKey])
        
        return components
    }
}
