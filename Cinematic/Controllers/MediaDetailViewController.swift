//
//  MediaDetailViewController.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 27.04.23.
//

import UIKit

class MediaDetailViewController: UIViewController {
    
    public var mediaID: Int?
    public var mediaType: MediaType?
    
    private var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let id = mediaID, let type = mediaType else { return }
        
        fetchMedia(by: id, and: type)
    }
    
    private func fetchMedia(by id: MovieID, and type: MediaType) {
        print("Movie: \(id), type: \(type.rawValue)")
    }

}
