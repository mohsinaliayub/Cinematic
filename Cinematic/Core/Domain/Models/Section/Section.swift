//
//  Section.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 02.05.23.
//

import Foundation

class Section {
    enum SectionID: Int {
        case trendingTVShows
        case popular
        case upcomingMovies
        
        var title: String {
            switch self {
            case .trendingTVShows: return "TV Shows"
            case .popular: return "Popular movies"
            case .upcomingMovies: return "Upcoming movies"
            }
        }
    }
    
    var id: SectionID
    var title: String {
        id.title
    }
    var pageToQueryNext: Int?
    private var items: [MediaSummary]
    var mediaSummaries: [MediaSummary] {
        get { items }
        set { items += newValue }
    }
    
    init(id: SectionID, pageToQueryNext: Int? = nil, mediaSummaries: [MediaSummary] = []) {
        self.id = id
        self.pageToQueryNext = pageToQueryNext
        self.items = mediaSummaries
    }
}

extension Section: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Section, rhs: Section) -> Bool {
        lhs.id == rhs.id
    }
}
