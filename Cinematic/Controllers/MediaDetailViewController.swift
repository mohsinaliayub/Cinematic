//
//  MediaDetailViewController.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 27.04.23.
//

import UIKit
import CinematicAPI

class MediaDetailViewController: UIViewController {
    private enum Section: Int {
        case detail
        case cast
        case recommendations
        
        static var numberOfSections: Int { return 3 }
    }
    private struct SectionItem: Hashable {
        let section: Section
        let item: Movie
    }
    
    private enum Constants {
        static let detailCell = "MediaDetailCell"
    }
    
    // Outlets
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            collectionView.dataSource = self
            collectionView.collectionViewLayout = collectionViewLayout()
            registerCellsAndSupplementaryViews()
            collectionView.reloadData()
        }
    }
    
    private var movie: Movie? {
        didSet {
            guard movie != nil else { return }
            collectionView.reloadData()
        }
    }
    private var recommendations: [MediaSummary] = []
//    private lazy var dataSource = configureDataSource()
    public var mediaID: Int?
    public var mediaType: MediaType?
    public var movieService: MovieFetcher!
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, SectionItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        
        guard let id = mediaID, let type = mediaType, mediaType == .movie else { return }
        
        fetchMedia(by: id, and: type)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        // ignore top safe area for backdrop image
        var insets = view.safeAreaInsets
        print(insets)
        insets.top = 0
        collectionView.contentInset = insets
    }
    
    private func fetchMedia(by id: MovieID, and type: MediaType) {
        Task.detached {
            do {
                let movie = try await self.movieService.fetchMovieDetails(for: .movie, by: id)
                await self.setMovieDetails(movie)
            } catch {
                print(error)
            }
        }
    }
    
    private func setMovieDetails(_ movie: Movie) {
        self.movie = movie
        
        
    }

    @IBAction private func dismissController() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Data Source and Snapshot

extension MediaDetailViewController {
    
    private func registerCellsAndSupplementaryViews() {
        let nib = UINib(nibName: Constants.detailCell, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constants.detailCell)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "empty")
    }
    
//    private func configureDataSource() -> DataSource {
//        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, movie in
//            let section = Section(rawValue: indexPath.section)!
//
//            switch section {
//            case .detail, .cast, .recommendations:
//                let cell = collectionView
//                    .dequeueReusableCell(withReuseIdentifier: Constants.detailCell,
//                                         for: indexPath) as? MediaDetailCell
//                cell?.setMovieDetails(movie)
//                return cell
//            }
//        }
//
//        return dataSource
//    }
//
//    private func applySnapshot(animatingDifferences: Bool = true) {
//        guard let movie = movie else { return }
//        var snapshot = Snapshot()
//        snapshot.appendSections([.detail, .cast, .recommendations])
//        snapshot.appendItems([movie], toSection: .detail)
//        snapshot.appendItems([movie], toSection: .cast)
//        snapshot.appendItems([movie], toSection: .recommendations)
//    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = Section(rawValue: sectionIndex)!
            
            let layoutSection: NSCollectionLayoutSection
            switch section {
            case .detail, .cast, .recommendations:
                layoutSection = self.mediaDetailCellSection
            }
            
            return layoutSection
        }
        return layout
    }
    
    private var mediaDetailCellSection: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(800))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}


extension MediaDetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // for 1st section, only return 1 item for media/tv details
        if section == 0 { return 1 }
        
        return 0 // right now, not implementing any other section
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = Section(rawValue: indexPath.section)!
        guard let movie = movie else { return collectionView.dequeueReusableCell(withReuseIdentifier: "empty", for: indexPath) }
        
        switch section {
        case .detail, .cast, .recommendations:
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: Constants.detailCell,
                                     for: indexPath) as! MediaDetailCell
            cell.setMovieDetails(movie)
            return cell
        }
        
    }
}
