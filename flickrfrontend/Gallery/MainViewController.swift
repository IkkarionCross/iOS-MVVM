//
//  MainViewController.swift
//  flickrfrontend
//
//  Created by victor amaro on 24/05/21.
//

import UIKit
import AppServices
import FlickrEntities

class MainViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var flickrGalleryViewController: FlickrGalleryViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
        
        if segue.identifier != "gallerySegue" {
            return
        }
        
        if let viewController = segue.destination as? FlickrGalleryViewController {
            let galleryService = GalleryService(
                usingQueue: DispatchQueue(label: "com.victoramaro.flickrfrontend.gallery"),
                searchDAO: SearchDAO(context: context))
            
            let photoSizeService = PhotoSizeService(
                usingQueue: DispatchQueue(label: "com.victoramaro.flickrfrontend.photo"),
                photoSizeDao: PhotoSizeDAO(context: context),
                photoDAO: PhotoDAO(context: context))
            
            self.flickrGalleryViewController = viewController
            self.flickrGalleryViewController?.viewModel = GalleryViewModel(
                galleryService: galleryService,
                sizeService: photoSizeService)
        }
    }
    
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.flickrGalleryViewController?.searchText = searchBar.text ?? ""
    }
}
