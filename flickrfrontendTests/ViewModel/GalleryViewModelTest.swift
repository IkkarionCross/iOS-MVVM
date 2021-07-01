//
//  flickrfrontendTests.swift
//  flickrfrontendTests
//
//  Created by victor amaro on 22/05/21.
//

import XCTest
import AppNetwork
import FlickrEntities
@testable import flickrfrontend

class GalleryViewModelTest: XCTestCase {
    
    class GalleryServiceMock: PGalleryService {
        private var receivedSearchText: String?
        private var receivedPage: Int?
        
        private(set) var searchWasCalled: Bool = false
        private(set) var fetchPhotosWasCalled: Bool = false
        
        var result: Completion<FlickrResults>
        
        init() {
            self.result = .failure(NetworkError.invalidDataReceived(requestDescription: "FetchPhotos"))
        }
        
        func search(text: String, _ completion: @escaping (Completion<FlickrResults>) -> Void) throws {
            self.receivedSearchText = text
            self.searchWasCalled = true
            completion(result)
        }
        
        func fetchPhotos(searchText: String, page: Int, _ completion: @escaping (Completion<FlickrResults>) -> Void) throws {
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
        var result: Completion<FlickrSize>
        
        init() {
            self.result = .failure(NetworkError.invalidDataReceived(requestDescription: "FetchPhotos"))
        }
        
        func fetchLargeSquarePhotoUrl(photoId: String, _ completion: @escaping (Completion<FlickrSize>) -> Void) throws {
            self.receivedPhotoId = photoId
            self.fetchLargeSquarePhotoUrlWasCalled = true
            completion(result)
        }
        
        func checkfetchLargeSquarePhotoUrl(expectedPhotoId: String) {
            XCTAssertEqual(expectedPhotoId, self.receivedPhotoId)
            XCTAssertTrue(fetchLargeSquarePhotoUrlWasCalled)
        }
        
    }
    
    var sut: GalleryViewModel!
    var galleryServiceMock: GalleryServiceMock!
    var photoSizeServiceMock: PhotoSizeServiceMock!

    override func setUpWithError() throws {        
        galleryServiceMock = GalleryServiceMock()
        photoSizeServiceMock = PhotoSizeServiceMock()
        
        sut = GalleryViewModel(galleryService: galleryServiceMock, sizeService: photoSizeServiceMock)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testShould_SearchForImages() throws {
        let expectedResultCount = 1
        let expectedSearchText = "gatinho"
        
        let expectedPhoto = FlickrPhoto(id: "1234", title: "teste gatinho", secret: "adsiuyf8", url: nil)
        let expectedPhotos = FlickrPhotos(page: 1, pages: 10, perpage: 100, total: 1000, photo: [expectedPhoto])
        let expectedResult = Completion<FlickrResults>.success(FlickrResults(photos: expectedPhotos, stat: ""))
        
        galleryServiceMock.result = expectedResult
        
        try sut.search(text: expectedSearchText) { result in
            XCTAssertEqual(expectedResultCount, self.sut.results.count)
        }
        
        galleryServiceMock.checkSearch(expectedSearchText: expectedSearchText)
    }
    
    func testShouldNot_SearchForImages_ServerError() throws {
        let expectedResultCount = 0
        let expectedSearchText = "gatinho"
        let expectedResult = Completion<FlickrResults>.failure(NetworkError.serverError(statusCode: "401", message: "Unauthorized"))
        
        galleryServiceMock.result = expectedResult
        
        try sut.search(text: expectedSearchText) { result in
            XCTAssertEqual(expectedResultCount, self.sut.results.count)
        }
        
        galleryServiceMock.checkSearch(expectedSearchText: expectedSearchText)
    }
    
    func testShouldFetchPhotos() throws {
        let expectedResultCount = 1
        let expectedPage = 1
        let expectedSearchText = "gatinho"
        
        let expectedPhoto = FlickrPhoto(id: "1234", title: "teste", secret: "adsiuyf8", url: nil)
        let expectedPhotos = FlickrPhotos(page: expectedPage, pages: 10, perpage: 100, total: 1000, photo: [expectedPhoto])
        let expectedResult = Completion<FlickrResults>.success(FlickrResults(photos: expectedPhotos, stat: ""))
        
        galleryServiceMock.result = expectedResult
        
        try sut.fetchPhotos(text: expectedSearchText, page: 1) { result in
            XCTAssertEqual(expectedResultCount, self.sut.results.count)
        }
        
        galleryServiceMock.checkFetchPhotos(expectedSearchText: expectedSearchText, expectedPage: expectedPage)
    }
    
    func testShouldFetchPhotos_WithLastSearch() throws {
        let expectedSearchResultCount = 1
        let expectedFetchResultCount = 2
        let expectedPage = 2
        let expectedSearchText = "teste"
        
        let expectedPhoto = FlickrPhoto(id: "1234", title: "teste", secret: "adsiuyf8", url: nil)
        let expectedPhotos = FlickrPhotos(page: expectedPage, pages: 10, perpage: 100, total: 1000, photo: [expectedPhoto])
        let expectedResult = Completion<FlickrResults>.success(FlickrResults(photos: expectedPhotos, stat: ""))
        
        galleryServiceMock.result = expectedResult
        
        try sut.search(text: expectedSearchText) { result in
            XCTAssertEqual(expectedSearchResultCount, self.sut.results.count)
        }
        
        galleryServiceMock.checkSearch(expectedSearchText: expectedSearchText)
        
        try sut.fetchPhotos(page: 2) { result in
            XCTAssertEqual(expectedFetchResultCount, self.sut.results.count)
            XCTAssertEqual(expectedPhotos.page, self.sut.lastLoadedPage)
            XCTAssertEqual(expectedPhotos.perpage, self.sut.perPage)
        }
        
        galleryServiceMock.checkFetchPhotos(expectedSearchText: expectedSearchText, expectedPage: expectedPage)
    }


}
