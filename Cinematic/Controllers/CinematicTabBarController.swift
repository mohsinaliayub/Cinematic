//
//  CinematicTabBarController.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 08.05.23.
//

import UIKit
import CinematicAPI

class CinematicTabBarController: UITabBarController {
    
    private var movieService: MovieFetcher = CinematicMovieService()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let vcs = viewControllers else { return }
        for controller in vcs {
            if let topRatedVC = controller as? TopRatedViewController {
                topRatedVC.movieService = movieService
            }
        }
    }

}
