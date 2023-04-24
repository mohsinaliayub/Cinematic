//
//  MediaSummary.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 10.02.23.
//

import Foundation

struct MediaSummary: Identifiable {
    let id: Int
    let title: String?
    let name: String?
    let backdropURL: URL?
    let posterURL: URL?
    let mediaType: MediaType
    
    var label: String? {
        title ?? name
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, name
        case backdropURL = "backdrop_path"
        case posterURL = "poster_path"
        case mediaType = "media_type"
    }
}

extension MediaSummary: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        mediaType = try container.decode(MediaType.self, forKey: .mediaType)
        let backdropImage = try container.decode(String.self, forKey: .backdropURL)
        let posterImage = try container.decode(String.self, forKey: .posterURL)
        
        backdropURL = URL(string: Constants.APIConstants.baseURLForImages + backdropImage)
        posterURL = URL(string: Constants.APIConstants.baseURLForImages + posterImage)
    }
}
