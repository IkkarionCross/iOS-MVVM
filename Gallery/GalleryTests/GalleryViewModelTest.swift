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

    func testShould_SearchForImages() throws {
        let expectedResultCount = 1
        let expectedSearchText = "gatinho"
        
        let expectedPhoto = PhotoMock(id: "1234", title: "teste gatinho", sizes: [])
        let expectedResult = Completion<PPhotoPageModel>.success(PhotoPageMock(page: 1, perPage: 100, photos: [expectedPhoto], pages: 1))
        
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
        let expectedResult = Completion<PPhotoPageModel>.success(PhotoPageMock(page: Int32(expectedPage), perPage: 100, photos: [expectedPhoto], pages: 1))
        
        galleryServiceMock.result = expectedResult
        
        try sut.fetchPhotos(text: expectedSearchText, page: 1) { result in
            XCTAssertEqual(expectedResultCount, self.sut.itemCount)
        }
        
        galleryServiceMock.checkFetchPhotos(expectedSearchText: expectedSearchText, expectedPage: expectedPage)
    }
    
    func testShouldNotFetchNextPage() throws {
        let expectedResultCount = 1
        let expectedPage = 1
        let expectedSearchText = "gatinho"
        
        let expectedPhoto = PhotoMock(id: "1234", title: "teste", sizes: [])
        let expectedResult = Completion<PPhotoPageModel>.success(PhotoPageMock(page: Int32(expectedPage), perPage: 100, photos: [expectedPhoto], pages: 1))
        
        galleryServiceMock.result = expectedResult
        
        try sut.fetchPhotos(text: expectedSearchText, page: 1) { result in
            XCTAssertEqual(expectedResultCount, self.sut.itemCount)
        }
        
        XCTAssertFalse(sut.shouldFetchNextPage(displayingCurrentItem: 0))
    }
    
    func testShouldFetchNextPage() throws {
        sut = GalleryViewModel(galleryService: galleryServiceMock, sizeService: photoSizeServiceMock, limitToLoadNewPages: 1)
        
        let expectedResultCount = 3
        let expectedPage = 1
        let expectedSearchText = "gatinho"
        
        let expectedPhoto = PhotoMock(id: "1234", title: "teste", sizes: [])
        let expectedResult = Completion<PPhotoPageModel>.success(PhotoPageMock(page: Int32(expectedPage), perPage: 3,
                                                                               photos: [expectedPhoto, expectedPhoto, expectedPhoto], pages: 2))
        
        galleryServiceMock.result = expectedResult
        
        try sut.fetchPhotos(text: expectedSearchText, page: 1) { result in
            XCTAssertEqual(expectedResultCount, self.sut.itemCount)
        }
        
        XCTAssertTrue(sut.shouldFetchNextPage(displayingCurrentItem: 2))
    }
    
    func testShouldCancelImageSizeTask() throws {
        let photo = PhotoMock(id: "1234", title: "teste", sizes: [])
        let photoSizeMock = PhotoSizeMock(type: "Large Square", url: "")
        let photoViewModel = PhotoViewModel(photo: photo)
        let indexPath = IndexPath(row: 0, section: 1)
        let expectedResult = Completion<[PPhotoSizeModel]>.success([photoSizeMock])
        let dummyCancelable = DummyCancelable()
        var expectedTaskCount = 1
        
        photoSizeServiceMock.result = expectedResult
        photoSizeServiceMock.deadlineAsync = 3.0
        photoSizeServiceMock.task = dummyCancelable
        
        try sut.fetchImage(forPhoto: photoViewModel, inIndexPath: indexPath) { result in }
        
        XCTAssertEqual(expectedTaskCount, sut.imageSizeTasksCount)
        
        sut.cancelImageRequest(forIndexPath: IndexPath(row: 0, section: 1))
        
        expectedTaskCount = 0
        XCTAssertEqual(expectedTaskCount, sut.imageSizeTasksCount)
        XCTAssertTrue(dummyCancelable.cancelWasCalled)
    }
}
