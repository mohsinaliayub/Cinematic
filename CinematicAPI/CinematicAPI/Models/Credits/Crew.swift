//
//  Crew.swift
//  CinematicAPI
//
//  Created by Mohsin Ali Ayub on 12.05.23.
//

import Foundation

struct Crew: Identifiable {
    /// A unique person ID.
    let id: Int
    /// The original name the person is known by in the world of media.
    let name: String
    /// URL of the profile photo
    let photoURL: URL?
    /// The kind of work performed by the cast member.
    let workDepartment: ProductionDepartment?
    /// The job performed by the crew member.
    let job: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, job
        case workDepartment = "known_for_department"
        case photoURL = "profile_path"
    }
}

extension Crew: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        workDepartment = try? container.decode(ProductionDepartment.self, forKey: .workDepartment)
        job = try container.decode(String.self, forKey: .job)
        
        if let photoURLString = try? container.decode(String.self, forKey: .photoURL) {
            photoURL = URL(string: Constants.APIConstants.baseURLForImages + photoURLString)
        } else {
            photoURL = nil
        }
    }
}
