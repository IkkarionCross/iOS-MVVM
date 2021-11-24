//
//  MainViewController.swift
//  flickrfrontend
//
//  Created by victor amaro on 24/05/21.
//

import UIKit
import AppServices
import FlickrEntities

class SearchViewController: UIViewController {
    
    lazy var contentView: UIView = {
        let content: UIView = UIView(frame: .zero)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.backgroundColor = .black
        return content
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar: UISearchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        return searchBar
    }()
    
    private var resultViewController: FlickrGalleryViewController?
    
    init(resultViewController: FlickrGalleryViewController) {
        super.init(nibName: nil, bundle: nil)
        
        self.resultViewController = resultViewController
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        arrangeSubViews()
    }
    
    func arrangeSubViews() {
        view.addSubview(searchBar)
        view.addSubview(contentView)
        
        if let resultViewController = resultViewController {
            resultViewController.willMove(toParent: self)
            self.contentView.addSubview(resultViewController.view)
            addChild(resultViewController)
            resultViewController.didMove(toParent: self)
        }
        
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        contentView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    deinit {
        self.resultViewController = nil
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.resultViewController?.searchText = searchBar.text ?? ""
    }
}
