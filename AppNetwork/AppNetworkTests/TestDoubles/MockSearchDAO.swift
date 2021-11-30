//
//  MockSearchDAO.swift
//  AppServices
//
//  Created by Victor Amaro on 16/08/21.
//

import XCTest
import Foundation
import FlickrEntities

class MockSearchDAO: PSearchDAO {
    var saveSearchResult: Completion<PPhotoPageModel>?
    var expectedFlickrResults: FlickrResults?
    
    private(set) var saveSearchWasCalled: Bool = false
    
    func lastSearch(withText text: String) throws -> SearchResultModel? {
        return nil
    }
    
    func savePageInLastSearch(withText text: String, andPage page: Int, fromNetworkResults results: FlickrResults, completion: (Completion<PPhotoPageModel>) -> Void) {
        
    }
    
    func page(forSearchText text: String, andPage pageNumber: Int) throws -> PPhotoPageModel? {
        return nil
    }
    
    func saveSearch(withText text: String, andPage page: Int, fromNetworkResults results: FlickrResults, completion: (Completion<PPhotoPageModel>) -> Void) {
        
        XCTAssertEqual(expectedFlickrResults?.photos.photo.count, results.photos.photo.count, "Received FlickrResults different than expected")
        
        self.saveSearchWasCalled = true
        
        completion(saveSearchResult!)
    }
    
    
}
