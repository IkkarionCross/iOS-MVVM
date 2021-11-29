//
//  GalleryView.swift
//  Gallery
//
//  Created by Victor Amaro on 29/11/21.
//

import UIKit

class GallerySearchController {
    
    private lazy var searchBar: UISearchBar = {
        let searchBar: UISearchBar = UISearchBar()
        searchBar.placeholder = "Search Image..."
        searchBar.sizeToFit()
        searchBar.delegate = delegate
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        return searchBar
    }()
    
    lazy var controller: UISearchController = {
        let searchController: UISearchController = UISearchController()
        searchController.searchBar.placeholder = "Search Image..."
        searchController.searchBar.delegate = delegate
        
        return searchController
    }()
    
    private weak var delegate: UISearchBarDelegate?
    
    init(delegate: UISearchBarDelegate) {
        self.delegate = delegate
    }
    
    
}
