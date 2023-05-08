//
//  PopularMediaCell.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 08.05.23.
//

import UIKit
import SDWebImage

class PopularMediaCell: UICollectionViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setMedia(_ media: MediaSummary) {
        titleLabel.text = media.label
        imageView.sd_setImage(with: media.backdropURL)
    }
    
}
