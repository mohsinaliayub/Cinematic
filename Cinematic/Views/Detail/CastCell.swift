//
//  CastCell.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 13.05.23.
//

import UIKit
import CinematicAPI

class CastCell: UICollectionViewCell {

    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func showCastDetails(_ cast: Cast) {
        characterLabel.text = cast.character
        nameLabel.text = cast.name
        photoImageView.sd_setImage(with: cast.photoURL)
    }
    
    
}
