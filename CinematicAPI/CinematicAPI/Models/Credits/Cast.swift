//
//  Cast.swift
//  CinematicAPI
//
//  Created by Mohsin Ali Ayub on 12.05.23.
//

import Foundation

public struct Cast: Identifiable {
    /// A unique person ID.
    public let id: Int
    /// The original name the person is known by in the world of media.
    public let name: String
    /// URL of the profile photo
    public let photoURL: URL?
    /// The character portrayed in the movie or tv.
    public let character: String
    /// The kind of work performed by the cast member.
    public let workDepartment: ProductionDepartment?
    /// The order of appearance.
    let order: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, order, character
        case workDepartment = "known_for_department"
        case photoURL = "profile_path"
    }
}

extension Cast: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        character = try container.decode(String.self, forKey: .character)
        workDepartment = try? container.decode(ProductionDepartment.self, forKey: .workDepartment)
        order = try container.decode(Int.self, forKey: .order)
        
        if let photoURLString = try? container.decode(String.self, forKey: .photoURL) {
            photoURL = URL(string: Constants.APIConstants.baseURLForImages + photoURLString)
        } else {
            photoURL = nil
        }
    }
}

extension Cast: Comparable {
    public static func < (lhs: Cast, rhs: Cast) -> Bool {
        lhs.order < rhs.order
    }
}


/// The work the person did in production of the movie or tv.
public enum ProductionDepartment: String, Codable {
    case acting = "Acting"
    case directing = "Directing"
}
