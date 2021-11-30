//
//  GalleryViewModel.swift
//  flickrfrontend
//
//  Created by victor amaro on 24/05/21.
//
import Foundation
import AppServices
import FlickrEntities

class GalleryViewModel {
    
    private var results: [PPhotoModel] = []
    private var lastLoadedPage: Int = 1
    private var perPage: Int = 0
    private var pages: Int = 0
    
    private var lastSearchText: String
    
    private let galleryService: PGalleryService!
    private let sizeService   : PPhotoSizeService!
    
    private var tasks: [Int: Cancelable] = [:]
    private let limitToLoadNewPages: Int
    
    private var downlimit: Int {
        return results.count - limitToLoadNewPages
    }
    
    var isLoading: Bool = false
    
    var nextPage: Int {
        let newPage = lastLoadedPage + 1
        if newPage > pages {
            return lastLoadedPage
        }
        return newPage
    }
    
    var itemCount: Int {
        return results.count
    }
    
    var imageSizeTasksCount: Int {
        return tasks.count
    }
    
    init(galleryService: PGalleryService, sizeService: PPhotoSizeService, limitToLoadNewPages: Int = 60) {
        self.galleryService = galleryService
        self.sizeService = sizeService
        self.lastSearchText = ""
        self.limitToLoadNewPages = limitToLoadNewPages
    }
    
    private func setResults(photoPage: PPhotoPageModel) {
        self.results = Array(photoPage.photos)
        self.perPage = Int(photoPage.perPage)
        self.pages = photoPage.pages
        self.lastLoadedPage = Int(photoPage.page)
        self.isLoading = false
    }
    
    private func appendResults(photoPage: PPhotoPageModel) {
        self.results.append(contentsOf: Array(photoPage.photos))
        self.lastLoadedPage = Int(photoPage.page)
        self.perPage = Int(photoPage.perPage)
        self.pages = photoPage.pages
    }
    
    func getPhoto(forIndex index: Int) -> PhotoViewModel {
        return PhotoViewModel(photo: results[index])
    }
    
    func search(text: String, _ completion: @escaping (Completion<Void>)->Void) throws {
        self.isLoading = true
        self.lastSearchText = text
        try galleryService.search(text: text) { result in
            self.isLoading = false
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
            self.isLoading = false
            switch result {
            case let .success(photoPage):
                var oldResults = [PPhotoModel]()
                oldResults.append(contentsOf: self.results)
                
                self.appendResults(photoPage: photoPage)
                
                completion(.success(()))
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchImage(forPhoto photo: PhotoViewModel, inIndexPath indexPath: IndexPath,
                                   _ completion: @escaping (Completion<URL>) -> Void) throws {
        let task = try sizeService.fetchSizes(forPhotoId: photo.id) { result in
            self.tasks.removeValue(forKey: indexPath.row)
            switch result {
            case let .success(results):
                guard let photoSize = results.first(where: { size in size.type == "Large Square" }) else {
                    return completion(.failure(DefaultError.unkwonError(title: "Photo without correct size")))
                }
                guard let photoUrl = URL(string: photoSize.url) else {
                    return completion(.failure(DefaultError.unkwonError(title: "Photo without url")))
                }
                completion(.success(photoUrl))
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
        self.tasks[indexPath.row] = task
    }
    
    func cancelImageRequest(forIndexPath indexPath: IndexPath) {
        self.tasks[indexPath.row]?.cancel()
        self.tasks.removeValue(forKey: indexPath.row)
    }
    
    func shouldFetchNextPage(displayingCurrentItem row: Int) -> Bool {
        return lastLoadedPage < pages && row >= downlimit && !isLoading
    }

}
