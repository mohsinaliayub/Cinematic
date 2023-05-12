//
//  Section.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 12.05.23.
//

import Foundation
import CinematicAPI

public class Section {
    public enum SectionID: Int {
        case trendingTVShows
        case popular
        case upcomingMovies
        
        public var title: String {
            switch self {
            case .trendingTVShows: return "TV Shows"
            case .popular: return "Popular movies"
            case .upcomingMovies: return "Upcoming movies"
            }
        }
    }
    
    public var id: SectionID
    public var title: String {
        id.title
    }
    public var pageToQueryNext: Int?
    private var items: [MediaSummary]
    var mediaItems: [MediaItem] {
        items.map { MediaItem(section: self, item: $0) }
    }
    
    public init(id: SectionID, pageToQueryNext: Int? = nil, mediaSummaries: [MediaSummary] = []) {
        self.id = id
        self.pageToQueryNext = pageToQueryNext
        self.items = mediaSummaries
    }
    
    /// Adds items to the end of `items` array.
    public func append(_ mediaSummaries: [MediaSummary]) {
        items += mediaSummaries
    }
}

extension Section: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Section, rhs: Section) -> Bool {
        lhs.id == rhs.id
    }
}
