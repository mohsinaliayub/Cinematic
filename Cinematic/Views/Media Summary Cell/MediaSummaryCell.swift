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
    }
}
