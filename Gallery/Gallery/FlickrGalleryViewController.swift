//
//  ViewController.swift
//  flickrfrontend
//
//  Created by victor amaro on 22/05/21.
//

import UIKit
import Kingfisher
import Coordinator
import common

class FlickrGalleryViewController: UICollectionViewController {
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(
      top: 50.0,
      left: 20.0,
      bottom: 50.0,
      right: 20.0)
    
    var indicatorView: UIActivityIndicatorView?
    
    private lazy var searchController: GallerySearchController = {
        return GallerySearchController(delegate: self)
    }()
    
    var viewModel: GalleryViewModel!
    
    var searchText: String = "" {
        didSet {
           displayActivityIndicator()
            do {
                if viewModel.itemCount > 0 {
                    collectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                  at: .top,
                                                  animated: true)
                }
                try viewModel.search(text: searchText) { result in
                    switch result {
                    case .success():
                        DispatchQueue.main.async { [weak self] in
                            self?.collectionView.reloadData()
                            self?.hideActivityIndicator()
                        }
                    case let .failure(error):
                        print(error.localizedDescription)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    var coordinator: GalleryCoordinator?
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = self.sectionInsets
        layout.itemSize = CGSize(width: 150, height: 165)
        
        super.init(collectionViewLayout: layout)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(FlickrPhotoCell.self, forCellWithReuseIdentifier: FlickrPhotoCell.reuseIdentifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsSelection = true
        
        navigationItem.searchController = searchController.controller
    }
    
    override func didReceiveMemoryWarning() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
    }
    
    private func loadImage(forCell cell: FlickrPhotoCell, inIndexPath indexPath: IndexPath) {
        let photo = viewModel.getPhoto(forIndex: indexPath.row)
        if let url = photo.url,
           ImageCache.default.isCached(forKey: url.absoluteString)
        {
            cell.setImage(withUrl: url)
            return
        }
        
        do {
            try self.viewModel.fetchImage(forPhoto: photo, inIndexPath: indexPath) { result in
                switch result {
                case let .success(url):
                    DispatchQueue.main.async {
                        cell.setImage(withUrl: url)
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoViewModel: PhotoViewModel = viewModel.getPhoto(forIndex: indexPath.row)
        coordinator?.showDetail(forDependency: GalleryDependencies(photo: photoViewModel))
    }
}

extension FlickrGalleryViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = viewModel.getPhoto(forIndex: indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickrPhotoCell.reuseIdentifier, for: indexPath) as! FlickrPhotoCell
        cell.configure(withPhoto: photo, router: self.coordinator)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let flickrCell = cell as! FlickrPhotoCell
        
        self.loadImage(forCell: flickrCell, inIndexPath: indexPath)
        
        if !viewModel.shouldFetchNextPage(displayingCurrentItem: indexPath.row) {
            return
        }
        
        do { // load more photos
            try self.viewModel.fetchPhotos(page: self.viewModel.nextPage) { result in
                switch result {
                case .success():
                    DispatchQueue.main.async { [weak self] in
                        self?.collectionView.reloadData()
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let flickCell = cell as! FlickrPhotoCell
        flickCell.clearForReuse()
        self.viewModel.cancelImageRequest(forIndexPath: indexPath)
    }
    
}

extension FlickrGalleryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
      ) -> CGFloat {
        return sectionInsets.left
      }
}

extension FlickrGalleryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = searchBar.text ?? ""
    }
}

extension FlickrGalleryViewController: Indictable {}
