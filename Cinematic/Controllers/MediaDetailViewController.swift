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
    
    private var movie: Movie?
    var movieService: MovieFetcher!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    }

}
