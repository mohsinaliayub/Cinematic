//
//  LayoutSectionHelper.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 13.05.23.
//

import UIKit

enum LayoutSectionHelper {
    typealias ScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehavior
    static func smallImageViewItemSection(withScrollingBehavior scrollingBehavior: ScrollingBehavior) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(120),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(360),
                                               heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = scrollingBehavior
        
        return section
    }
    
}
