//
//  MediaSummary.swift
//  CinematicAPI
//
//  Created by Mohsin Ali Ayub on 12.05.23.
//

import Foundation

public struct MediaSummary: Identifiable {
    public let id: Int
    private let title: String?
    private let name: String?
    public let overview: String
    public let backdropURL: URL?
    public let posterURL: URL?
    public let mediaType: MediaType
    public let genreIds: [Int]
    private let releaseDate: Date?
    var genres: [Genre] = []
    
    public var label: String? {
        title ?? name
    }
    
    public var releaseDateString: String? {
        guard let date = releaseDate else { return nil }
        //        return monthDayYearFormatter.string(from: date)
        return yearFormatter.string(from: date)
    }
    
    private var monthDayYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM DD YYYY"
        return formatter
    }()
    
    private var shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        return formatter
    }()
    
    private var yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    enum CodingKeys: String, CodingKey {
        case id, title, name, overview
        case releaseDate = "release_date"
        case backdropURL = "backdrop_path"
        case posterURL = "poster_path"
        case mediaType = "media_type"
        case genreIds = "genre_ids"
    }
}

extension MediaSummary: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        overview = try container.decode(String.self, forKey: .overview)
        mediaType = try container.decodeIfPresent(MediaType.self, forKey: .mediaType) ?? .movie
        genreIds = try container.decodeIfPresent([Int].self, forKey: .genreIds) ?? []
        if let backdropImage = try container.decodeIfPresent(String.self, forKey: .backdropURL) {
            backdropURL = URL(string: Constants.APIConstants.baseURLForImages + backdropImage)
        } else {
            backdropURL = nil
        }
        if let posterImage = try container.decodeIfPresent(String.self, forKey: .posterURL) {
            posterURL = URL(string: Constants.APIConstants.baseURLForImages + posterImage)
        } else {
            posterURL = nil
        }
        
        if let releaseDateString = try container.decodeIfPresent(String.self, forKey: .releaseDate) {
            releaseDate = shortDateFormatter.date(from: releaseDateString)
        } else {
            releaseDate = nil
        }
    }
}

extension MediaSummary: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: MediaSummary, rhs: MediaSummary) -> Bool {
        lhs.id == rhs.id
    }
}
