//
//  TopRatedViewController.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 08.05.23.
//

import UIKit
import CinematicAPI

class TopRatedViewController: UIViewController {
    enum TopRatedSection: CaseIterable {
        case all
    }
    enum Constants {
        static let topRatedCell = "TopRatedMediaCell"
    }
    
    typealias TopRatedDataSource = UICollectionViewDiffableDataSource<TopRatedSection, MediaSummary>
    typealias TopRatedSnapshot = NSDiffableDataSourceSnapshot<TopRatedSection, MediaSummary>

    @IBOutlet private weak var backgroundImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.collectionViewLayout = collectionViewLayout()
        }
    }
    var topRatedMedia: [MediaSummary] = [] {
        didSet {
            applySnapshot()
        }
    }
    
    var movieService: MovieFetcher = CinematicMovieService()
    lazy var dataSource = configureDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
        fetchTopRatedMovies()
    }
    
    private func registerCells() {
        let nib = UINib(nibName: Constants.topRatedCell, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constants.topRatedCell)
    }
    
    private func fetchTopRatedMovies() {
        Task {
            do {
                let movies = try await movieService.fetchPopularMovies()
                self.topRatedMedia = movies
            } catch {
                print(error)
            }
        }
    }

}

// MARK: - Collection View Data Source, Snapshot

extension TopRatedViewController {
    private func configureDataSource() -> TopRatedDataSource {
        let dataSource = TopRatedDataSource(collectionView: collectionView) { collectionView, indexPath, mediaSummary in
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: Constants.topRatedCell,
                                     for: indexPath) as? TopRatedMediaCell
            
            cell?.setMedia(mediaSummary)
            cell?.delegate = self
            return cell
        }
        
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = TopRatedSnapshot()
        snapshot.appendSections([.all])
        snapshot.appendItems(topRatedMedia, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - Compositional Layout
extension TopRatedViewController {
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            self.topRatedMoviesSection()
        }
        return layout
    }
    
    private func topRatedMoviesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }
    
}

extension TopRatedViewController: TopRatedMediaCellDelegate {
    func poster(url: URL?) {
        backgroundImage.sd_setImage(with: url)
    }
}
