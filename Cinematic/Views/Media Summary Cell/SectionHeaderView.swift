//
//  SectionHeaderView.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 02.05.23.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    
    @IBOutlet private weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func set(label: String) {
        titleLabel.text = label
    }
    
}
