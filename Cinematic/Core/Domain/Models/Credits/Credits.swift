//
//  Credits.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 10.02.23.
//

import Foundation

struct Credits: Decodable {
    let id: Int
    let cast: [Cast]
    let crew: [Crew]
}
