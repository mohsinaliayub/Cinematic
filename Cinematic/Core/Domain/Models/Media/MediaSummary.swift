//
//  MediaSummary.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 10.02.23.
//

import Foundation

struct MediaSummary: Identifiable {
    let id: Int
    private let title: String?
    private let name: String?
    let overview: String
    let backdropURL: URL?
    let posterURL: URL?
    let mediaType: MediaType
    private let releaseDate: Date?
    
    var label: String? {
        title ?? name
    }
    
    var releaseDateString: String? {
        guard let date = releaseDate else { return nil }
        return monthDayYearFormatter.string(from: date)
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
    
    enum CodingKeys: String, CodingKey {
        case id, title, name, overview
        case releaseDate = "release_date"
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
        overview = try container.decode(String.self, forKey: .overview)
        mediaType = try container.decode(MediaType.self, forKey: .mediaType)
        let backdropImage = try container.decode(String.self, forKey: .backdropURL)
        let posterImage = try container.decode(String.self, forKey: .posterURL)
        
        backdropURL = URL(string: Constants.APIConstants.baseURLForImages + backdropImage)
        posterURL = URL(string: Constants.APIConstants.baseURLForImages + posterImage)
        let releaseDateString = try container.decode(String.self, forKey: .releaseDate)
        releaseDate = shortDateFormatter.date(from: releaseDateString)
    }
}
