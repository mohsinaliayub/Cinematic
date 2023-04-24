//
//  TrendingMoviesViewController.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 24.04.23.
//

import UIKit

class TrendingMoviesViewController: UIViewController {
    
    private let movieService = CinematicMovieService()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchTrendingMovies()
    }
    
    func fetchTrendingMovies() {
        Task {
            do {
                let trendingMovies = try await movieService.fetchTrendingMovies()
                print(trendingMovies.count)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
