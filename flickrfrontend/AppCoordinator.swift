//
//  AppCoordinator.swift
//  flickrfrontend
//
//  Created by Victor Amaro on 10/10/21.
//

import UIKit
import CoreData
import AppServices
import FlickrEntities

class AppCoordinator {
    
    let context: NSManagedObjectContext
    let navController: UINavigationController
    
    init(context: NSManagedObjectContext, navController: UINavigationController) {
        self.context = context
        self.navController = navController
    }
    
    func initialViewController() {
        let searchViewController: SearchViewController = createSearchView()
        navController.pushViewController(searchViewController, animated: true)
    }
    
    func showPhotoDetail(forPhoto photo: PhotoViewModel) {
        let detailController: PhotoDetailViewController = PhotoDetailViewController(viewModel: photo)
        detailController.coordinator = self
        navController.show(detailController, sender: nil)
    }
    
    private func createSearchView() -> SearchViewController {
        let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
        
        let galleryService = GalleryService(
            usingQueue: DispatchQueue(label: "com.victoramaro.flickrfrontend.gallery"),
            searchDAO: SearchDAO(context: context))
        
        let photoSizeService = PhotoSizeService(
            usingQueue: DispatchQueue(label: "com.victoramaro.flickrfrontend.photo"),
            photoSizeDao: PhotoSizeDAO(context: context),
            photoDAO: PhotoDAO(context: context))
        
        let galleryViewController: FlickrGalleryViewController = FlickrGalleryViewController()
        galleryViewController.coordinator = self
        galleryViewController.viewModel = GalleryViewModel(
            galleryService: galleryService,
            sizeService: photoSizeService)
        
        return SearchViewController(resultViewController: galleryViewController)
    }
    
    
}
