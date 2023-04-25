//
//  TrendingMoviesViewController.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 24.04.23.
//

import UIKit

class TrendingMoviesViewController: UIViewController {
    enum Constants {
        static let searchAndFilterCell = "SearchAndFilterCell"
        static let mediaSummaryCell = "mediaCell"
    }
    
    
    // Outlets
    @IBOutlet private weak var mediaTableView: UITableView!
    private weak var searchAndFilterHeaderView: SearchAndFilterCell!
    
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

        let nib = UINib(nibName: Constants.searchAndFilterCell, bundle: nil)
        mediaTableView.register(nib, forCellReuseIdentifier: Constants.searchAndFilterCell)
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

}

extension TrendingMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // 2 sections, 1st section contains only search field, and second section contains item
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : trendingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section == 1 else {
            return searchAndFilterCell(for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.mediaSummaryCell, for: indexPath)
        
        let media = trendingMovies[indexPath.row]
        var contentConfig = UIListContentConfiguration.subtitleCell()
        
        contentConfig.text = media.label
        contentConfig.secondaryText = media.mediaType.rawValue
        
        cell.contentConfiguration = contentConfig
        
        return cell
    }
    
    private func searchAndFilterCell(for indexPath: IndexPath) -> SearchAndFilterCell {
        let cell = mediaTableView
            .dequeueReusableCell(withIdentifier: Constants.searchAndFilterCell,
                                 for: indexPath) as! SearchAndFilterCell
        cell.delegate = self
        return cell
    }
    
}

extension TrendingMoviesViewController: SearchAndFilterHeaderViewDelegate {
    
    func search(_ text: String?) {
        
    }
    
    func showFilters() {
        
    }
    
}
