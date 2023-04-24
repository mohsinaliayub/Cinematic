//
//  TrendingMoviesViewController.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 24.04.23.
//

import UIKit

class TrendingMoviesViewController: UIViewController {
    
    // Outlets
    @IBOutlet private weak var mediaTableView: UITableView!
    
    // Properties
    private var trendingMovies = [MediaSummary]() {
        didSet {
            DispatchQueue.main.async {
                self.mediaTableView.reloadData()
            }
        }
    }
    private let movieService = CinematicMovieService()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchTrendingMovies()
    }
    
    func fetchTrendingMovies() {
        Task {
            do {
                trendingMovies = try await movieService.fetchTrendingMovies()
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

extension TrendingMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    private var cellName: String {
        "mediaCell"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trendingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)
        
        let media = trendingMovies[indexPath.row]
        var contentConfig = UIListContentConfiguration.subtitleCell()
        
        contentConfig.text = media.label
        contentConfig.secondaryText = media.mediaType.rawValue
        
        cell.contentConfiguration = contentConfig
        
        return cell
    }
    
    
}
