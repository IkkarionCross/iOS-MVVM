//
//  ViewController.swift
//  flickrfrontend
//
//  Created by victor amaro on 22/05/21.
//

import UIKit
import Kingfisher

class FlickrGalleryViewController: UICollectionViewController {
    private let reuseIdentifier = "FlickrCell"
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(
      top: 50.0,
      left: 20.0,
      bottom: 50.0,
      right: 20.0)
    
    private var placeHolderImage: UIImage = UIImage(systemName: "photo")!
    
    private let indicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    var viewModel: GalleryViewModel!
    
    // mover logica para dentro do viewmodel. O viewModel precisa de um delegate para aviasr ao viewcontroller para
    // carregar os resultados
    var searchText: String = "" {
        didSet {
           displayActivityIndicator()
            do {
                collectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                  at: .top,
                                                  animated: true)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
    }
    
    private func displayActivityIndicator() {
        view.addSubview(indicatorView)
        indicatorView.center = view.center
        
        indicatorView.startAnimating()
    }
    
    private func hideActivityIndicator() {
        indicatorView.stopAnimating()
        indicatorView.removeFromSuperview()
    }
    
    func loadImage(forCell cell: FlickrPhotoCell, inIndexPath indexPath: IndexPath) {
        let photo = viewModel.getPhoto(forIndex: indexPath.row)
        if let url = photo.largeSquareImageUrl,
           ImageCache.default.isCached(forKey: url)
        {
            cell.setImage(withUrl: URL(string: url)!, andPlaceHolder: placeHolderImage)
            return
        }
        
        do {
            try self.viewModel.fetchImage(forPhoto: photo,
                                                     inIndexPath: indexPath) { result in
                switch result {
                case let .success(photoSize):
                    DispatchQueue.main.async { [weak self] in
                        if let url = URL(string: photoSize.url) {
                            cell.setImage(withUrl: url, andPlaceHolder: self?.placeHolderImage)
                        }
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

extension FlickrGalleryViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = viewModel.getPhoto(forIndex: indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickrPhotoCell
        cell.configure(withPhoto: photo, imagePlaceHolder: placeHolderImage)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let flickrCell = cell as! FlickrPhotoCell
        
        self.loadImage(forCell: flickrCell, inIndexPath: indexPath)
        
        if viewModel.shouldFetchNextPage(displayingCurrentItem: indexPath.row) {
            try! self.viewModel.fetchPhotos(page: self.viewModel.nextPage) { result in
                switch result {
                case .success():
                    DispatchQueue.main.async { [weak self] in
                        self?.viewModel.isLoading = false
                        self?.collectionView.reloadData()
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let flickCell = cell as! FlickrPhotoCell
        flickCell.clearForReuse(withPlaceHolder: placeHolderImage)
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
