//
//  SearchAndFilterCell.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 25.04.23.
//

import UIKit

protocol SearchAndFilterHeaderViewDelegate: AnyObject {
    func search(_ text: String?)
    func showFilters()
}

class SearchAndFilterCell: UITableViewCell {
    
    @IBOutlet private weak var searchField: UISearchTextField!
    @IBOutlet private weak var filterImageView: UIImageView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(filterImageTapped))
            filterImageView.addGestureRecognizer(tap)
        }
    }
    
    weak var delegate: SearchAndFilterHeaderViewDelegate?
    
    @objc private func filterImageTapped() {
        delegate?.showFilters()
    }
}

extension SearchAndFilterCell: UITextFieldDelegate, UISearchTextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        delegate?.search(nil)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.search(textField.text)
        return true
    }
}
