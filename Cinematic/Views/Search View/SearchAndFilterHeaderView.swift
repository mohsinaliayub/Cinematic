//
//  SearchAndFilterHeaderView.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 25.04.23.
//

import UIKit

enum SortCriteria: String {
    case trending = "Trending"
    case popular = "Popular"
}

protocol SearchAndFilterHeaderViewDelegate: AnyObject {
    func search(_ text: String?)
    func sort(by criteria: SortCriteria)
}

class SearchAndFilterHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet private weak var searchField: UISearchTextField!
    @IBOutlet private weak var filterImageView: UIImageView!
    @IBOutlet private weak var sortButton: UIButton!
    
    weak var delegate: SearchAndFilterHeaderViewDelegate?
    
    // If the title of button is trending, sort on trending and change the label to "popular"
    // and vice versa.
    @IBAction func sortButtonTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == SortCriteria.trending.rawValue {
            sender.setTitle(SortCriteria.popular.rawValue, for: .normal)
            delegate?.sort(by: .trending)
        } else {
            sender.setTitle(SortCriteria.trending.rawValue, for: .normal)
            delegate?.sort(by: .popular)
        }
    }
}

extension SearchAndFilterHeaderView: UITextFieldDelegate, UISearchTextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        delegate?.search(nil)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.search(textField.text)
        return true
    }
}
