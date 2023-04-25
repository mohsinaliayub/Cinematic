//
//  TrendingMoviesViewController.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 24.04.23.
//

import UIKit

class TrendingMoviesViewController: UIViewController {
    enum Constants {
        static let searchAndFilterHeaderView = "SearchAndFilterHeaderView"
        static let cellName = "mediaCell"
    }
    
    
    // Outlets
    @IBOutlet private weak var mediaTableView: UITableView!
    private weak var searchAndFilterHeaderView: SearchAndFilterHeaderView!
    
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

        let nib = UINib(nibName: Constants.searchAndFilterHeaderView, bundle: nil)
        mediaTableView.register(nib, forHeaderFooterViewReuseIdentifier: Constants.searchAndFilterHeaderView)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trendingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellName, for: indexPath)
        
        let media = trendingMovies[indexPath.row]
        var contentConfig = UIListContentConfiguration.subtitleCell()
        
        contentConfig.text = media.label
        contentConfig.secondaryText = media.mediaType.rawValue
        
        cell.contentConfiguration = contentConfig
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.searchAndFilterHeaderView) as? SearchAndFilterHeaderView
        
        return headerView
    }
    
}

extension TrendingMoviesViewController: SearchAndFilterHeaderViewDelegate {
    
    func search(_ text: String?) {
        
    }
    
    func sort(by criteria: SortCriteria) {
        
    }
    
}
