//
//  MediaCell.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 27.04.23.
//

import UIKit
import SDWebImage

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
    
    private let imageDownloader: ImageDownloader = CinematicImageDownloader()
    
    func display(mediaSummary: MediaSummary) {
        mediaNameLabel.text = mediaSummary.label
        posterImageView.sd_setImage(with: mediaSummary.posterURL)
    }
}
