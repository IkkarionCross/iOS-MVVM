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

public enum GalleryFlow: String, AppFlow {
    case login
}

public struct GalleryDependencies: Dependencies {
    let photo: PhotoViewModel
    
    init(photo: PhotoViewModel) {
        self.photo = photo
    }
}

public class GalleryCoordinator: BaseCoordinator<GalleryFlow> {
    
    private let context: NSManagedObjectContext
    private let navController: UINavigationController
    
    public init(context: NSManagedObjectContext, navController: UINavigationController) {
        self.context = context
        self.navController = navController
    }
    
    public override func start() {
        self.navController.pushViewController(galleryFlow(), animated: false)
        coordinator(forFlow: .login)?.start()
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
