//
//  FlickrPhotos.swift
//  flickrfrontend
//
//  Created by victor amaro on 22/05/21.
//

import Foundation

struct FlickrResults: Deserializable {
    let photos: FlickrPhotos
    let stat: String
}

struct FlickrPhotos: Deserializable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photo: [FlickrPhoto]
}

class FlickrPhoto: Deserializable {
    let id: String
    let title: String
    let secret: String
    var url: String?
}

struct FlickrSizesResults: Deserializable {
    let sizes: FlickrSizes
}

struct FlickrSizes: Deserializable {
    let size: [FlickrSize]
}

struct FlickrSize: Deserializable {
    let label: String
    let source: String
    let url: String
    let width: Int
    let height: Int
}
