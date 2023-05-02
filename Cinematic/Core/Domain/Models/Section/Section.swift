//
//  Section.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 02.05.23.
//

import Foundation

class Section {
    enum SectionID: Int {
        case trendingMovies
        case trendingTVShows
        
        var title: String {
            switch self {
            case .trendingMovies: return "Trending Movies"
            case .trendingTVShows: return "Trending TV Shows"
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
