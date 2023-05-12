//
//  PopularMediaCell.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 08.05.23.
//

import UIKit
import CinematicAPI
import SDWebImage

class PopularMediaCell: UICollectionViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var genresLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setMedia(_ media: MediaSummary) {
        titleLabel.text = media.label
        imageView.sd_setImage(with: media.backdropURL)
        
        Task {
            do {
                let genres = try await GenreService.shared.genresByIds(media.genreIds,
                                                                       for: media.mediaType)
                genresLabel.text = genres.prefix(3).map { $0.name }.joined(separator: ", ")
            } catch { }
        }
    }
    
}
