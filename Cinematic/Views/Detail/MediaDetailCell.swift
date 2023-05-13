//
//  MediaDetailCell.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 13.05.23.
//

import UIKit
import CinematicAPI

class MediaDetailCell: UICollectionViewCell {

    // Outlets
    @IBOutlet private weak var backdropImageView: UIImageView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var playTrailerButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var runtimeLabel: UILabel!
    @IBOutlet private weak var starImageView: UIImageView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func setMovieDetails(_ movie: Movie) {
        titleLabel.text = movie.title
        runtimeLabel.text = movie.runtimeInHours
        ratingLabel.text = String(format: "%.1f", movie.rating)
        descriptionLabel.text = movie.overview
        genreLabel.text = movie.genres.prefix(2).map { $0.name }.joined(separator: "/")
        
        backdropImageView.sd_setImage(with: movie.backdropPathURL)
        posterImageView.sd_setImage(with: movie.posterPathURL)
    }
    
}
