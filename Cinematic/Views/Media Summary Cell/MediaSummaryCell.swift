//
//  MediaSummaryCell.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 25.04.23.
//

import UIKit

class MediaSummaryCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var mediaTypeLabel: UILabel!
    @IBOutlet private weak var mediaOverviewLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var mediaPosterImageView: UIImageView!
    @IBOutlet weak var mediaBackdropImageView: UIImageView!
    @IBOutlet weak var container: UIView!
    
    private let imageDownloader: ImageDownloader = CinematicImageDownloader()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func show(media: MediaSummary) {
        titleLabel.text = media.label
        mediaTypeLabel.text = media.mediaType.rawValue.capitalized
        mediaOverviewLabel.text = media.overview
        releaseDateLabel.text = media.releaseDateString
        
        // TODO: Set image view
        downloadAndDisplayImage(on: mediaBackdropImageView, from: media.backdropURL)
    }
    
    private func downloadAndDisplayImage(on imageView: UIImageView, from url: URL?) {
        guard let url = url else { return }
        
        Task {
            if let image = try? await imageDownloader.downloadImage(from: url) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
    }
    
}
