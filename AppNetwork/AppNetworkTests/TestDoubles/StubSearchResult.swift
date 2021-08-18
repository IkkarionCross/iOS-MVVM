//
//  StubSearchResult.swift
//  AppServices
//
//  Created by Victor Amaro on 17/08/21.
//

import Foundation
import FlickrEntities

struct StubSearchResult: PSearchResultModel {
    var createdAt: Date
    var searchText: String
    var pages: [PPhotoPageModel]
}
