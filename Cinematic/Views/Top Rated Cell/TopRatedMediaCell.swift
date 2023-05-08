//
//  TopRatedMediaCell.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 08.05.23.
//

import UIKit
import SDWebImage

class TopRatedMediaCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setMedia(_ media: MediaSummary) {
        titleLabel.text = media.label
        releaseDateLabel.text = media.releaseDateString
        posterImageView.sd_setImage(with: media.posterURL)
    }
    
}
