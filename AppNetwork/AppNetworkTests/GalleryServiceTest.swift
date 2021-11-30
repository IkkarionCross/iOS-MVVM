//
//  AppNetworkTests.swift
//  AppNetworkTests
//
//  Created by victor amaro on 26/05/21.
//

import XCTest
import OHHTTPStubs
import FlickrEntities
@testable import AppServices

class GalleryServiceTest: XCTestCase {
    
    var sut: GalleryService!
    var mockSearchDAO: MockSearchDAO!
    
    override func setUpWithError() throws {
        mockSearchDAO = MockSearchDAO()
        sut = GalleryService(usingQueue: DispatchQueue(label: "com.victoramaro.test"),
                             searchDAO: mockSearchDAO)
    }
    
    func testShould_SearchForImages() throws {
        let expectedPhoto  = FlickrPhoto(id: "1234", title: "teste gatinho", secret: "adsiuyf8", url: nil)
        let expectedPhotos = FlickrPhotos(page: 1, pages: 10, perpage: 100, total: 1000, photo: [expectedPhoto])
        let expectedResult = FlickrResults(photos: expectedPhotos, stat: "")
        let encodedResult: Data = try! JSONEncoder().encode(expectedResult)
        let obj = try! JSONSerialization.jsonObject(with: encodedResult, options: .allowFragments) as! [String: Any]
        
        stub(condition: isHost(BaseRouter.host)) { _ in
            return HTTPStubsResponse(jsonObject: obj, statusCode: 200, headers: nil)
        }
        let searchResult = StubSearchResult(createdAt: Date(), searchText: "cat", pages: [])
        let expectedPhotoPage = StubPhotoPage(pages: 1, page: 1, perPage: 100, photos: [], search: searchResult)
        
        let expectation = expectation(description: "Expect Image Search")

        mockSearchDAO.saveSearchResult = .success(expectedPhotoPage)
        mockSearchDAO.expectedFlickrResults = expectedResult
        
        try sut.search(text: "cat") { result in
            switch (result) {
            case .success:
                XCTAssertTrue(self.mockSearchDAO.saveSearchWasCalled)
            case let .failure(error):
                XCTFail("Failure is not expected, error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testShouldNot_SearchForImages_ServerError_500() throws {
        let expectedError = NetworkError.serverError(statusCode: "500", message: "Response status code was unacceptable: 500.")
        
        let expectedStatusCode: Int32 = 500
        stub(condition: isHost(BaseRouter.host)) { _ in
            return HTTPStubsResponse(jsonObject: [], statusCode: expectedStatusCode, headers: nil)
        }
        
        let expectedSearchText = "cat"
        let expectation = expectation(description: "Expect Image Search")
        
        try sut.search(text: expectedSearchText) { result in
            switch (result) {
            case .success(_):
                XCTFail("Success is not expected")
            case let .failure(error):
                XCTAssertEqual(expectedError.localizedDescription, error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
}
