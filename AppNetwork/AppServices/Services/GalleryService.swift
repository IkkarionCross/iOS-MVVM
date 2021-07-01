//
//  GalleryService.swift
//  flickrfrontend
//
//  Created by victor amaro on 24/05/21.
//

import Foundation
import FlickrEntities

public protocol PGalleryService {
    func search(text: String, _ completion: @escaping (Completion<PhotoPageEntity>)->Void) throws
    func fetchPhotos(searchText: String, page: Int, _ completion: @escaping (Completion<PhotoPageEntity>)->Void) throws
}

public class GalleryService: PGalleryService {
    public typealias DataType = PhotoEntity
    
    private let queue: DispatchQueue
    private let restService: RESTService<FlickrResults>
    private let searchDAO: SearchDAO
    
    public init(usingQueue queue: DispatchQueue, searchDAO: SearchDAO) {
        self.queue = queue
        self.restService = RESTService<FlickrResults>()
        self.searchDAO = searchDAO
    }
    
    // have to solve this callback hell using combine
    public func search(text: String, _ completion: @escaping (Completion<PhotoPageEntity>)->Void) throws {
        if let savedPhotoPage = try searchDAO.lastSearch(withText: text)?.pages.first {
            completion(.success(savedPhotoPage))
            return
        }
        
        let request = APIFlickr.searchImages(tag: text, page: 1)
        try self.restService.retrieveData(request: request, queue: queue) { serviceResult in
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
    
    public func fetchPhotos(searchText: String, page: Int, _ completion: @escaping (Completion<PhotoPageEntity>)->Void) throws {
        if let savedPhotoPage = try searchDAO.page(forSearchText: searchText, andPage: page) {
            completion(.success(savedPhotoPage))
            return
        }
        
        
        let request = APIFlickr.searchImages(tag: searchText, page: page)
        try self.restService.retrieveData(request: request, queue: queue) { serviceResult in
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

extension GalleryService: DataService {}

