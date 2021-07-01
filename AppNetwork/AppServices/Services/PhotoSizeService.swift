//
//  PhotoDetailService.swift
//  flickrfrontend
//
//  Created by victor amaro on 24/05/21.
//

import Foundation
import FlickrEntities

public protocol PPhotoSizeService {
    func fetchSizes(forPhotoId photoId: String, _ completion: @escaping (Completion<[PhotoSizeEntity]>) -> Void) throws
}

public class PhotoSizeService {
    private let queue: DispatchQueue
    private let restService: RESTService<FlickrSizesResults>
    private let photoSizeDao: PhotoSizeDAO
    private let photoDAO: PhotoDAO
    
    public init(usingQueue queue: DispatchQueue, photoSizeDao: PhotoSizeDAO, photoDAO: PhotoDAO) {
        self.queue = queue
        self.restService = RESTService<FlickrSizesResults>()
        self.photoSizeDao = photoSizeDao
        self.photoDAO = photoDAO
    }
}

extension PhotoSizeService: PPhotoSizeService {
    public func fetchSizes(forPhotoId photoId: String, _ completion: @escaping (Completion<[PhotoSizeEntity]>) -> Void) throws {
        if let photoSizes = try photoDAO.photo(forId: photoId)?.sizes {
            return completion(.success(Array(photoSizes)))
        }
        
        let request = APIFlickr.listSizes(photoId: photoId)
        try self.restService.retrieveData(request: request, queue: queue) { result in
            switch result {
            case let .success(results):
                self.photoSizeDao.save(sizesForPhotoId: photoId, fromNeworkResults: results.sizes.size) { saveResult in
                        completion(saveResult)
                    }
            case let .failure(error):
                completion(.failure(error))
            }
        }
        
    }
}
