//
//  MediaCell.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 27.04.23.
//

import UIKit
import SDWebImage
import CinematicAPI

class MediaCell: UICollectionViewCell {
    @IBOutlet private weak var mediaNameLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView! {
        didSet {
            posterImageView.layer.cornerRadius = 5
            posterImageView.clipsToBounds = true
        }
    }
    
    public var posterImage: UIImage? {
        posterImageView.image
    }
    
    func display(mediaSummary: MediaSummary) {
        mediaNameLabel.text = mediaSummary.label
        posterImageView.sd_setImage(with: mediaSummary.posterURL)
    }
}
