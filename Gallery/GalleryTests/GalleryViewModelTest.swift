//
//  flickrfrontendTests.swift
//  flickrfrontendTests
//
//  Created by victor amaro on 22/05/21.
//

import XCTest
import AppServices
import FlickrEntities
@testable import Gallery

class GalleryViewModelTest: XCTestCase {
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
        
        let expectedPhoto = PhotoMock(id: "1234", title: "teste gatinho", sizes: [])
        let expectedResult = Completion<PPhotoPageModel>.success(PhotoPageMock(page: 1, perPage: 100, photos: [expectedPhoto]))
        
        galleryServiceMock.result = expectedResult
        
        try sut.search(text: expectedSearchText) { result in
            XCTAssertEqual(expectedResultCount, self.sut.itemCount)
        }
        
        galleryServiceMock.checkSearch(expectedSearchText: expectedSearchText)
    }
    
    func testShouldNot_SearchForImages_ServerError() throws {
        let expectedResultCount = 0
        let expectedSearchText = "gatinho"
        let expectedResult = Completion<PPhotoPageModel>.failure(NetworkError.serverError(statusCode: "401", message: "Unauthorized"))
        
        galleryServiceMock.result = expectedResult
        
        try sut.search(text: expectedSearchText) { result in
            XCTAssertEqual(expectedResultCount, self.sut.itemCount)
        }
        
        galleryServiceMock.checkSearch(expectedSearchText: expectedSearchText)
    }
    
    func testShouldFetchPhotos() throws {
        let expectedResultCount = 1
        let expectedPage = 1
        let expectedSearchText = "gatinho"
        
        let expectedPhoto = PhotoMock(id: "1234", title: "teste", sizes: [])
        let expectedResult = Completion<PPhotoPageModel>.success(PhotoPageMock(page: Int32(expectedPage), perPage: 100, photos: [expectedPhoto]))
        
        galleryServiceMock.result = expectedResult
        
        try sut.fetchPhotos(text: expectedSearchText, page: 1) { result in
            XCTAssertEqual(expectedResultCount, self.sut.itemCount)
        }
        
        galleryServiceMock.checkFetchPhotos(expectedSearchText: expectedSearchText, expectedPage: expectedPage)
    }
    
    func testShouldFetchPhotos_WithLastSearch() throws {

    }


}
