//
//  File.swift
//  flickrfrontend
//
//  Created by Victor Amaro on 23/10/21.
//

import UIKit
import CoreData
import Coordinator
import AppServices
import FlickrEntities


public struct GalleryDependencies: Dependencies {
    let photo: PhotoViewModel
    
    init(photo: PhotoViewModel) {
        self.photo = photo
    }
    
}

public class GalleryCoordinator: PGalleryCoordinator {
    
    let context: NSManagedObjectContext
    let navController: UINavigationController
    let loginCoordinator: Coordinator
    
    init(context: NSManagedObjectContext, navController: UINavigationController, loginCoordinator: Coordinator) {
        self.context = context
        self.navController = navController
        self.loginCoordinator = loginCoordinator
    }
    
    public func start() {
        self.navController.pushViewController(galleryFlow(), animated: false)
        self.loginCoordinator.start()
    }
    
    private func galleryFlow() -> FlickrGalleryViewController {
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
        
        return galleryViewController
    }
    
    public func showDetail(forDependency: GalleryDependencies) {
        let detailController: PhotoDetailViewController = PhotoDetailViewController(viewModel: forDependency.photo)
        detailController.coordinator = self
        navController.show(detailController, sender: nil)
    }
}
