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
        static let mediaSummaryCell = "MediaSummaryCell"
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

        registerCells(for: mediaTableView)
        fetchTrendingMovies()
    }
    
    private func registerCells(for tableView: UITableView) {
        var nib = UINib(nibName: Constants.searchAndFilterCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.searchAndFilterCell)
        
        nib = UINib(nibName: Constants.mediaSummaryCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.mediaSummaryCell)
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
            return searchAndFilterCell(for: tableView, with: indexPath)
        }
        
        return mediaSummaryCell(for: tableView, with: indexPath)
    }
    
    private func searchAndFilterCell(for tableView: UITableView, with indexPath: IndexPath) -> SearchAndFilterCell {
        let cell = tableView
            .dequeueReusableCell(withIdentifier: Constants.searchAndFilterCell,
                                 for: indexPath) as! SearchAndFilterCell
        cell.delegate = self
        return cell
    }
    
    private func mediaSummaryCell(for tableView: UITableView, with indexPath: IndexPath) -> MediaSummaryCell {
        let cell = tableView
            .dequeueReusableCell(withIdentifier: Constants.mediaSummaryCell,
                                 for: indexPath) as! MediaSummaryCell
        let media = trendingMovies[indexPath.row]
        cell.show(media: media)
        
        return cell
    }
    
}

extension TrendingMoviesViewController: SearchAndFilterHeaderViewDelegate {
    
    func search(_ text: String?) {
        
    }
    
    func showFilters() {
        
    }
    
}
