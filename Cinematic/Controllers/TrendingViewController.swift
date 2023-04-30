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
        static let showMediaDetailSegueId = "showMediaDetail"
    }
    
    enum Section {
        case trendingMovies
    }
    private typealias TrendingDataSource = UICollectionViewDiffableDataSource<Section, MediaSummary>
    private typealias TrendingSnapshot = NSDiffableDataSourceSnapshot<Section, MediaSummary>
    
    // Outlets
    @IBOutlet weak var trendingMediaCollectionView: UICollectionView!
    
    // properties
    private let movieService = CinematicMovieService()
    private var trendingMovies = [MediaSummary]() {
        didSet {
            applySnapshot()
        }
    }
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        fetchTrendingMovies()
        applySnapshot(animatingDifferences: false)
    }
    
    // MARK: Functions
    
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
    
    private func makeDataSource() -> TrendingDataSource {
        let dataSource = TrendingDataSource(collectionView: trendingMediaCollectionView) { collectionView, indexPath, media in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.mediaCell, for: indexPath) as? MediaCell
            
            cell?.display(mediaSummary: media)
            return cell
        }
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = TrendingSnapshot()
        snapshot.appendSections([.trendingMovies])
        snapshot.appendItems(trendingMovies, toSection: .trendingMovies)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.showMediaDetailSegueId,
           let indexPath = sender as? IndexPath {
            let detailVC = segue.destination as! MediaDetailViewController
            let movie = dataSource.itemIdentifier(for: indexPath)
            detailVC.mediaID = movie?.id
            detailVC.mediaType = movie?.mediaType
        }
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

extension TrendingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.showMediaDetailSegueId, sender: indexPath)
    }
    
}
