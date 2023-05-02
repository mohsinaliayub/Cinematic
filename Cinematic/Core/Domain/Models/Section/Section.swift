//
//  Section.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 02.05.23.
//

import Foundation

class Section {
    var id = UUID()
    var title: String
    var pageToQueryNext: Int
    var mediaSummaries: [MediaSummary]
    
    init(title: String, pageToQueryNext: Int, mediaSummaries: [MediaSummary]) {
        self.title = title
        self.pageToQueryNext = pageToQueryNext
        self.mediaSummaries = mediaSummaries
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
