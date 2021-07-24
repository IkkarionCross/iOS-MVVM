//
//  GalleryViewModel.swift
//  flickrfrontend
//
//  Created by victor amaro on 24/05/21.
//
import UIKit
import Foundation
import AppServices
import FlickrEntities

class GalleryViewModel {
    
    private var results: [PhotoEntity] = []
    private var lastLoadedPage: Int = 1
    private var perPage: Int = 0
    private var pages: Int = 0
    
    private var lastSearchText: String
    
    private let galleryService: PGalleryService!
    private let sizeService   : PPhotoSizeService!
    
    private var downlimit: Int {
        return results.count - 80
    }
    
    var isLoading: Bool = false
    
    var nextPage: Int {
        return lastLoadedPage + 1
    }
    
    var itemCount: Int {
        return results.count
    }
    
    init(galleryService: PGalleryService, sizeService: PPhotoSizeService) {
        self.galleryService = galleryService
        self.sizeService = sizeService
        self.lastSearchText = ""
    }
    
    private func setResults(photoPage: PhotoPageEntity) {
        self.results = Array(photoPage.photos)
        self.perPage = Int(photoPage.perPage)
        self.pages = 100
        self.lastLoadedPage = Int(photoPage.page)
        self.isLoading = false
    }
    
    private func appendResults(photoPage: PhotoPageEntity) {
        self.results.append(contentsOf: Array(photoPage.photos))
        self.lastLoadedPage = Int(photoPage.page)
        self.perPage = Int(photoPage.perPage)
        self.pages = 100
    }
    
    func getPhoto(forIndex index: Int) -> PhotoViewModel {
        return PhotoViewModel(photo: results[index])
    }
    
    func search(text: String, _ completion: @escaping (Completion<Void>)->Void) throws {
        self.isLoading = true
        self.lastSearchText = text
        try galleryService.search(text: text) { result in
            switch result {
            case let .success(photoPage):
                self.setResults(photoPage: photoPage)
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPhotos(text: String? = nil, page: Int, _ completion: @escaping (Completion<Void>)->Void) throws {
        self.isLoading = true
        
        let searchText: String
        if let search = text {
            searchText = search
        } else {
            searchText = self.lastSearchText
        }
        
        try galleryService.fetchPhotos(searchText: searchText, page: page) { result in
            switch result {
            case let .success(photoPage):
                var oldResults = [PhotoEntity]()
                oldResults.append(contentsOf: self.results)
                
                self.appendResults(photoPage: photoPage)
                
                completion(.success(()))
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchLargeSquarePhotoSize(forPhoto photo: PhotoViewModel, _ completion: @escaping (Completion<PhotoSizeEntity>) -> Void) throws {
        try sizeService.fetchSizes(forPhotoId: photo.id) { result in
            switch result {
            case let .success(results):
                guard let photoSize = results.getPhotoSize(withType: "Large Square") else {
                    return completion(.failure(DefaultError.unkwonError(title: "Photo without correct size")))
                }
                
                completion(.success(photoSize))
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func shouldFetchNextPage(displayingCurrentItem row: Int) -> Bool {
        return lastLoadedPage < pages && row >= downlimit && !isLoading
    }

}
