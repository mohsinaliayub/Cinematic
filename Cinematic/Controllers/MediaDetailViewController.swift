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
        
        var label: String {
            switch self {
            case .detail: return ""
            case .cast: return "Cast"
            case .recommendations: return "Recommendations"
            }
        }
        
        static var numberOfSections: Int { return 3 }
    }
    
    private enum Constants {
        static let detailCell = "MediaDetailCell"
        static let castCell = "CastCell"
        static let sectionHeader = "SectionHeaderView"
    }
    
    // Outlets
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.collectionViewLayout = collectionViewLayout()
            registerCellsAndSupplementaryViews()
            collectionView.reloadData()
        }
    }
    private lazy var backButton: UIButton! = {
        var button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        
        let origin = CGPoint(x: 16, y: 59)
        let size = CGSize(width: 50, height: 50)
        button.frame = CGRect(origin: origin, size: size)
        button.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        
        return button
    }()
    
    private var movie: Movie? {
        didSet {
            guard movie != nil else { return }
            collectionView.reloadData()
        }
    }
    private var cast: [Cast] {
        guard let movie = movie else { return [] }
        
        return movie.cast.count > 10 ? Array(movie.cast.prefix(10)) : movie.cast
    }
    private var recommendations: [MediaSummary] = []
    public var mediaID: Int?
    public var mediaType: MediaType?
    public var movieService: MovieFetcher!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        view.addSubview(backButton)
        
        guard let id = mediaID, let type = mediaType, mediaType == .movie else { return }
        
        fetchMedia(by: id, and: type)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        backButton.removeFromSuperview()
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

    @objc private func dismissController() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Compositional Layout

extension MediaDetailViewController {
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = Section(rawValue: sectionIndex)!
            
            let layoutSection: NSCollectionLayoutSection
            switch section {
            case .detail, .recommendations:
                layoutSection = self.mediaDetailCellSection
            case .cast:
                layoutSection = self.castCellSection
            }
            
            guard section != .detail else { return layoutSection }
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(44.0))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            layoutSection.boundarySupplementaryItems = [header]
            layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16,
                                                                  bottom: 4, trailing: 0)
            
            return layoutSection
        }
        return layout
    }
    
    private var mediaDetailCellSection: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(700))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private var castCellSection: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(120))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(80),
                                               heightDimension: .estimated(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .fixed(0),
            top: .fixed(0),
            trailing: .fixed(12),
            bottom: .fixed(8))
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
}

// MARK: - Collection View Data Source

extension MediaDetailViewController: UICollectionViewDataSource {
    
    private func registerCellsAndSupplementaryViews() {
        var nib = UINib(nibName: Constants.detailCell, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constants.detailCell)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "empty")
        
        nib = UINib(nibName: Constants.castCell, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constants.castCell)
        
        // register header view
        nib = UINib(nibName: Constants.sectionHeader, bundle: nil)
        collectionView
            .register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: Constants.sectionHeader)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // for 1st section, only return 1 item for media/tv details
        if section == 0 { return 1 }
        
        // TODO: implement for both movie and tv media type
        return section == 1 ? cast.count : recommendations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = Section(rawValue: indexPath.section)!
        guard let movie = movie else { return collectionView.dequeueReusableCell(withReuseIdentifier: "empty", for: indexPath) }
        
        switch section {
        case .detail, .recommendations:
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: Constants.detailCell,
                                     for: indexPath) as! MediaDetailCell
            cell.setMovieDetails(movie)
            return cell
        case .cast:
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: Constants.castCell,
                                     for: indexPath) as! CastCell
            cell.showCastDetails(cast[indexPath.row])
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView
            .dequeueReusableSupplementaryView(ofKind: kind,
                                              withReuseIdentifier: Constants.sectionHeader,
                                              for: indexPath) as! SectionHeaderView
        let section = Section(rawValue: indexPath.section)!
        headerView.set(label: section.label)
        headerView.isHidden = section == .detail
        return headerView
    }
}
