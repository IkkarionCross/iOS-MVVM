//
//  ServiceMock.swift
//  GalleryTests
//
//  Created by Victor Amaro on 24/11/21.
//

import Foundation
import XCTest
import AppServices
import FlickrEntities

class DummyCancelable: Cancelable {
    var cancelWasCalled: Bool = false
    func cancel() {
        cancelWasCalled = true
    }
}

class GalleryServiceMock: PGalleryService {
    private var receivedSearchText: String?
    private var receivedPage: Int?
    
    private(set) var searchWasCalled: Bool = false
    private(set) var fetchPhotosWasCalled: Bool = false
    
    var result: Completion<PPhotoPageModel>
    
    init() {
        self.result = .failure(NetworkError.invalidDataReceived(requestDescription: "FetchPhotos"))
    }
    
    func search(text: String, _ completion: @escaping (Completion<PPhotoPageModel>) -> Void) throws {
        self.receivedSearchText = text
        self.searchWasCalled = true
        completion(result)
    }
    
    func fetchPhotos(searchText: String, page: Int, _ completion: @escaping (Completion<PPhotoPageModel>) -> Void) throws {
        self.receivedSearchText = searchText
        self.receivedPage = page
        self.fetchPhotosWasCalled = true
        completion(result)
    }
    
    func checkSearch(expectedSearchText: String) {
        
        XCTAssertEqual(expectedSearchText, self.receivedSearchText)
        XCTAssertTrue(searchWasCalled)
    }
    
    func checkFetchPhotos(expectedSearchText: String, expectedPage: Int) {
        
        XCTAssertEqual(expectedSearchText, self.receivedSearchText)
        XCTAssertEqual(expectedPage      , self.receivedPage)
        XCTAssertTrue(fetchPhotosWasCalled)
    }
}


class PhotoSizeServiceMock: PPhotoSizeService {
    private var receivedPhotoId: String?
    private(set) var fetchLargeSquarePhotoUrlWasCalled: Bool = false
    var result: Completion<[PPhotoSizeModel]>
    var task: Cancelable?
    
    init() {
        self.result = .failure(NetworkError.invalidDataReceived(requestDescription: "FetchPhotos"))
    }
    
    func fetchSizes(forPhotoId photoId: String, _ completion: @escaping (Completion<[PPhotoSizeModel]>) -> Void) throws -> Cancelable? {
        self.receivedPhotoId = photoId
        self.fetchLargeSquarePhotoUrlWasCalled = true
        completion(result)
        return task
    }
    
    func checkfetchLargeSquarePhotoUrl(expectedPhotoId: String) {
        XCTAssertEqual(expectedPhotoId, self.receivedPhotoId)
        XCTAssertTrue(fetchLargeSquarePhotoUrlWasCalled)
    }
    
}
