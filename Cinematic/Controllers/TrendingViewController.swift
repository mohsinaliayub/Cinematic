//
//  TrendingViewController.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 27.04.23.
//

import UIKit

class TrendingViewController: UIViewController {
    enum Constants {
        static let mediaCell = "MediaCell"
        static let sizeForCell = CGSize(width: 120, height: 160)
        static let sectionInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    // Outlets
    @IBOutlet weak var trendingMediaCollectionView: UICollectionView!
    
    // properties
    private let movieService = CinematicMovieService()
    private var trendingMovies = [MediaSummary]() {
        didSet {
            trendingMediaCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        fetchTrendingMovies()
    }
    
    private func registerCell() {
        let nib = UINib(nibName: Constants.mediaCell, bundle: nil)
        trendingMediaCollectionView.register(nib, forCellWithReuseIdentifier: Constants.mediaCell)
    }
    
    private func fetchTrendingMovies() {
        Task {
            do {
                trendingMovies = try await movieService.fetchTrendingMovies()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension TrendingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trendingMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: Constants.mediaCell,
                                 for: indexPath) as! MediaCell
        
        let movie = trendingMovies[indexPath.row]
        cell.display(mediaSummary: movie)
        
        return cell
    }
    
}

extension TrendingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        sizeForCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        Constants.sectionInsets
    }
    
    private func sizeForCell() -> CGSize {
        // Calculate the size for each cell.
        Constants.sizeForCell
    }
    
}
