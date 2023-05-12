//
//  Genre.swift
//  CinematicAPI
//
//  Created by Mohsin Ali Ayub on 12.05.23.
//

import Foundation

public struct Genre: Codable {
    let id: Int
    public let name: String
}

struct GenreResult: Codable {
    let genres: [Genre]
}
