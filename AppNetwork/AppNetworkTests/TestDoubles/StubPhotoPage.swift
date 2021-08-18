//
//  StubPhotoPage.swift
//  AppServices
//
//  Created by Victor Amaro on 17/08/21.
//

import Foundation
import FlickrEntities

struct StubPhotoPage: PPhotoPageModel {
    var page: Int32
    var perPage: Int32
    var photos: [PPhotoModel]
    var search: PSearchResultModel
    
    
}
