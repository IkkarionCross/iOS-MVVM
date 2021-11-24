//
//  EntitiesMock.swift
//  GalleryTests
//
//  Created by Victor Amaro on 24/11/21.
//

import Foundation
import FlickrEntities

struct PhotoSizeMock: PPhotoSizeModel {
    var type: String
    var url: String
}

struct PhotoMock: PPhotoModel {
    var id: String
    var title: String
    var sizes: [PPhotoSizeModel]
}

struct PhotoPageMock: PPhotoPageModel {
    var page: Int32
    var perPage: Int32
    var photos: [PPhotoModel]
}
