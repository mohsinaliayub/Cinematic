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
        static let sectionHeader = "SectionHeaderView"
        static let sizeForCell = CGSize(width: 120, height: 160)
        static let sectionInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        static let showMediaDetailSegueId = "showMediaDetail"
    }
    
    
    private typealias TrendingDataSource = UICollectionViewDiffableDataSource<Section, MediaSummary>
    private typealias TrendingSnapshot = NSDiffableDataSourceSnapshot<Section, MediaSummary>
    
    // Outlets
    @IBOutlet weak var trendingMediaCollectionView: UICollectionView!
    
    // properties
    
    private let movieService = CinematicMovieService()
    private var sections = [Section]()
    private var trendingMovies = [MediaSummary]() {
        didSet {
            applySnapshot()
        }
    }
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trendingMediaCollectionView.collectionViewLayout = generateContinuousScrollingLayout()
        
        registerCellsAndSupplementaryViews()
        applySnapshot(animatingDifferences: false)
        fetchDataFromAPI()
    }
    
    // MARK: Functions
    
    private func registerCellsAndSupplementaryViews() {
        var nib = UINib(nibName: Constants.mediaCell, bundle: nil)
        trendingMediaCollectionView.register(nib, forCellWithReuseIdentifier: Constants.mediaCell)
        
        // register header view
        nib = UINib(nibName: Constants.sectionHeader, bundle: nil)
        trendingMediaCollectionView
            .register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: Constants.sectionHeader)
    }
    
    
    private func fetchDataFromAPI() {
        Task {
            do {
                try await fetchTrendingMovies()
                try await fetchTrendingTVShows()
                
                // reload the data
                applySnapshot()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchTrendingMovies() async throws {
        // Get the relevant section for trending Movies or create a new one.
        let section: Section
        if let moviesSection = sections.first(where: { $0.id == .trendingMovies }) {
            section = moviesSection
        } else {
            section = Section(id: .trendingMovies)
            sections.append(section)
        }
        
        let (pageToQueryNext, movies) = try await movieService.fetchTrending(mediaType: .movie, fromPage: section.pageToQueryNext)
        
        section.pageToQueryNext = pageToQueryNext
        section.mediaSummaries = movies
    }
    
    private func fetchTrendingTVShows() async throws {
        // Get the relevant section for trending Movies or create a new one.
        let section: Section
        if let moviesSection = sections.first(where: { $0.id == .trendingTVShows }) {
            section = moviesSection
        } else {
            section = Section(id: .trendingTVShows)
            sections.append(section)
        }
        
        let (pageToQueryNext, movies) = try await movieService.fetchTrending(mediaType: .tv, fromPage: section.pageToQueryNext)
        
        section.pageToQueryNext = pageToQueryNext
        section.mediaSummaries = movies
    }
    
    // MARK: CollectionView Data Source & Snapshot
    
    private func makeDataSource() -> TrendingDataSource {
        let dataSource = TrendingDataSource(collectionView: trendingMediaCollectionView) { collectionView, indexPath, media in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.mediaCell, for: indexPath) as? MediaCell
            
            cell?.display(mediaSummary: media)
            return cell
        }
        
        // set the header view
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            
            let headerView = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.sectionHeader,
                                                  for: indexPath) as? SectionHeaderView
            let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
            headerView?.set(label: section.title)
            
            return headerView
        }
        
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = TrendingSnapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.mediaSummaries, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func generateContinuousScrollingLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(120),
                                               heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
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

extension TrendingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.showMediaDetailSegueId, sender: indexPath)
    }
    
}
