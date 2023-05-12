//
//  MediaDetailViewController.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 27.04.23.
//

import UIKit
import CinematicAPI

class MediaDetailViewController: UIViewController {
    
    public var mediaID: Int?
    public var mediaType: MediaType?
    
    // Outlets
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var playTrailerButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var movie: Movie?
    var movieService: MovieFetcher!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        
        guard let id = mediaID, let type = mediaType, mediaType == .movie else { return }
        
        fetchMedia(by: id, and: type)
    }
    
    private func fetchMedia(by id: MovieID, and type: MediaType) {
        Task.detached {
            do {
                let movie = try await self.movieService.fetchMovieDetails(for: .movie, by: id)
                await self.setMovieDetails(movie)
            } catch {
                print(error)
            }
        }
    }
    
    private func setMovieDetails(_ movie: Movie) {
        self.movie = movie
        
        titleLabel.text = movie.title
        runtimeLabel.text = movie.runtimeInHours
        ratingLabel.text = String(format: "%.1f", movie.rating)
        descriptionLabel.text = movie.overview
        genreLabel.text = movie.genres.prefix(2).map { $0.name }.joined(separator: "/")
        
        backdropImageView.sd_setImage(with: movie.backdropPathURL)
        posterImageView.sd_setImage(with: movie.posterPathURL)
    }

    @IBAction private func dismissController() {
        self.navigationController?.popViewController(animated: true)
    }
}
