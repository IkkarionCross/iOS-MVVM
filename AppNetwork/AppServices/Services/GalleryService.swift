//
//  GalleryService.swift
//  flickrfrontend
//
//  Created by victor amaro on 24/05/21.
//

import Foundation
import FlickrEntities

public protocol PGalleryService {
    func search(text: String, _ completion: @escaping (Completion<PPhotoPageModel>)->Void) throws
    func fetchPhotos(searchText: String, page: Int, _ completion: @escaping (Completion<PPhotoPageModel>)->Void) throws
}

public class GalleryService {
    public typealias DataType = FlickrResults
    
    private let queue: DispatchQueue
    private let searchDAO: PSearchDAO
    
    public init(usingQueue queue: DispatchQueue, searchDAO: PSearchDAO) {
        self.queue = queue
        self.searchDAO = searchDAO
    }
    
    public func search(text: String, _ completion: @escaping (Completion<PPhotoPageModel>)->Void) throws {
        if let savedPhotoPage = try searchDAO.lastSearch(withText: text)?.pages.first {
            completion(.success(savedPhotoPage))
            return
        }
        
        let request = APIFlickr.searchImages(tag: text, page: 1)
        try self.retrieveData(request: request, queue: queue) { serviceResult in
            switch serviceResult {
            case let .success(flickrResult):
                self.searchDAO.saveSearch(withText: text, andPage: 1, fromNetworkResults: flickrResult, completion: { saveResult in
                    completion(saveResult)
                })
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    public func fetchPhotos(searchText: String, page: Int, _ completion: @escaping (Completion<PPhotoPageModel>)->Void) throws {
        if let savedPhotoPage = try searchDAO.page(forSearchText: searchText, andPage: page) {
            completion(.success(savedPhotoPage))
            return
        }
        
        
        let request = APIFlickr.searchImages(tag: searchText, page: page)
        try self.retrieveData(request: request, queue: queue) { serviceResult in
            switch serviceResult {
            case let .success(flickrResult):
                self.searchDAO
                    .savePageInLastSearch(withText: searchText,
                                          andPage: page,
                                          fromNetworkResults: flickrResult) { saveResult in
                        completion(saveResult)
                    }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    
}

extension GalleryService: NetworkService {}
extension GalleryService: PGalleryService {}

