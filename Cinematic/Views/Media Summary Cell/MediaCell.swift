//
//  MediaCell.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 27.04.23.
//

import UIKit

class MediaCell: UICollectionViewCell {
    @IBOutlet private weak var mediaNameLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    
    public var posterImage: UIImage? {
        get { posterImageView.image }
        set {
            guard let image = newValue else { mediaNameLabel.isHidden = false; return }
            DispatchQueue.main.async {
                self.posterImageView.image = image
                self.mediaNameLabel.isHidden = true
            }
        }
    }
    
    private let imageDownloader: ImageDownloader = CinematicImageDownloader()
    
    func display(mediaSummary: MediaSummary) {
        mediaNameLabel.text = mediaSummary.label
        downloadAndDisplayPoster(from: mediaSummary.posterURL)
    }
    
    private func downloadAndDisplayPoster(from url: URL?) {
        guard let url = url else { return }
        
        Task {
            do {
                let posterImage = try await self.imageDownloader.downloadImage(from: url)
                self.posterImage = posterImage
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
