//
//  Video.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 10.02.23.
//

import Foundation

struct VideoResult: Codable {
    let id: Int
    let videos: [Video]
    
    enum CodingKeys: String, CodingKey {
        case id
        case videos = "results"
    }
}

struct Video: Codable {
    let id: Int
    let name: String
    let official: Bool
    let type: VideoType?
    let site: String
    let key: String
}

enum VideoType: String, Codable {
    case trailer = "Trailer"
    case featurette = "Featurette"
    case clip = "Clip"
    case behindTheScenes = "Behind the Scenes"
    case teaser = "Teaser"
}
