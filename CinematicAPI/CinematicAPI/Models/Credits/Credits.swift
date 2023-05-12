//
//  Credits.swift
//  CinematicAPI
//
//  Created by Mohsin Ali Ayub on 12.05.23.
//

import Foundation

struct Credits: Decodable {
    let cast: [Cast]
    let crew: [Crew]
}
