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
    
    private enum Constants {
        static let detailCell = "MediaDetailCell"
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
                                               heightDimension: .estimated(700))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

// MARK: - Collection View Data Source

extension MediaDetailViewController: UICollectionViewDataSource {
    
    private func registerCellsAndSupplementaryViews() {
        let nib = UINib(nibName: Constants.detailCell, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constants.detailCell)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "empty")
    }
    
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
