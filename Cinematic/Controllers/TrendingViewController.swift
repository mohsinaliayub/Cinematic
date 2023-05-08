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
        static let popularCell = "PopularMediaCell"
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
        
        trendingMediaCollectionView.collectionViewLayout = generateCollectionViewLayout()
        
        registerCellsAndSupplementaryViews()
        applySnapshot(animatingDifferences: false)
        fetchDataFromAPI()
    }
    
    // MARK: Functions
    
    private func registerCellsAndSupplementaryViews() {
        var nib = UINib(nibName: Constants.mediaCell, bundle: nil)
        trendingMediaCollectionView.register(nib, forCellWithReuseIdentifier: Constants.mediaCell)
        
        nib = UINib(nibName: Constants.popularCell, bundle: nil)
        trendingMediaCollectionView.register(nib, forCellWithReuseIdentifier: Constants.popularCell)
        
        // register header view
        nib = UINib(nibName: Constants.sectionHeader, bundle: nil)
        trendingMediaCollectionView
            .register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: Constants.sectionHeader)
    }
    
    
    private func fetchDataFromAPI() {
        Task {
            do {
                let popularSection = section(for: .popular)
                let moviesSection = section(for: .trendingMovies)
                let tvSection = section(for: .trendingTVShows)
                
                async let popularMovies = try await movieService.fetchPopularMovies()
                async let trendingMovies = try await fetchTrending(for: moviesSection, withMediaType: .movie)
                async let trendingTVShows = try await fetchTrending(for: tvSection, withMediaType: .tv)
                
                let (popular, movies, tvs) = try await (popularMovies, trendingMovies, trendingTVShows)
                popularSection.mediaSummaries = popular
                moviesSection.mediaSummaries = movies
                tvSection.mediaSummaries = tvs
                
                // reload the data
                applySnapshot()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchTrending(for section: Section, withMediaType mediaType: MediaType) async throws -> [MediaSummary] {
        let (pageToQueryNext, media) = try await movieService.fetchTrending(mediaType: mediaType, fromPage: section.pageToQueryNext)
        section.pageToQueryNext = pageToQueryNext
        return media
    }
    
    private func section(for sectionType: Section.SectionID) -> Section {
        let section: Section
        if let foundSection = sections.first(where: { $0.id == sectionType }) {
            section = foundSection
        } else {
            section = Section(id: sectionType)
            sections.append(section)
        }
        return section
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.showMediaDetailSegueId,
           let indexPath = sender as? IndexPath {
            let detailVC = segue.destination as! MediaDetailViewController
            let movie = dataSource.itemIdentifier(for: indexPath)
            detailVC.movieService = movieService
            detailVC.mediaID = movie?.id
            detailVC.mediaType = movie?.mediaType
        }
    }
}

// MARK: - CollectionView Layout, Data Source & Snapshot

extension TrendingViewController {
    
    private func makeDataSource() -> TrendingDataSource {
        let dataSource = TrendingDataSource(collectionView: trendingMediaCollectionView) { collectionView, indexPath, media in
            
            let section = self.sections[indexPath.section]
            switch section.id {
            case .popular:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.popularCell,
                                                              for: indexPath) as? PopularMediaCell
                cell?.setMedia(media)
                return cell
                
            case .trendingMovies, .trendingTVShows:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.mediaCell, for: indexPath) as? MediaCell
                
                cell?.display(mediaSummary: media)
                return cell
            }
        }
        
        // set the header view
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            
            let headerView = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.sectionHeader,
                                                  for: indexPath) as? SectionHeaderView
            let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
            headerView?.set(label: section.title)
            headerView?.isHidden = section.id == .popular
            
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
    
    private func generateCollectionViewLayout() -> UICollectionViewLayout {
        let collectionViewLayout = UICollectionViewCompositionalLayout {
            sectionIndex, layoutEnvironment in
            
            let section = self.sections[sectionIndex]
            switch section.id {
            case .trendingMovies, .trendingTVShows:
                return self.generateContinuousScrollingSection()
            case .popular:
                return self.generatePopularMoviesSection()
            }
        }
        
        return collectionViewLayout
    }
    
    private func generatePopularMoviesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5,
                                                     bottom: 2.5, trailing: 2.5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95),
                                               heightDimension: .fractionalWidth(9 / 16))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func generateContinuousScrollingSection() -> NSCollectionLayoutSection {
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
        
        return section
    }
}

// MARK: - Collection View Delegate

extension TrendingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.showMediaDetailSegueId, sender: indexPath)
    }
    
}
