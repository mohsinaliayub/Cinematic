//
//  CinematicTabBarController.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 08.05.23.
//

import UIKit
import CinematicAPI

class CinematicTabBarController: UITabBarController {
    
    private let movieService: MovieFetcher = CinematicMovieService()
    private let genreService = GenreService()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let vcs = viewControllers else { return }
        for controller in vcs {
            guard let navController = controller as? UINavigationController else { continue }
            
            if let vc = navController.viewControllers.first as? HomeViewController {
                vc.movieService = movieService
            } else if let vc = navController.viewControllers.first as? SearchViewController {
                vc.movieService = movieService
            }
        }
    }

}
