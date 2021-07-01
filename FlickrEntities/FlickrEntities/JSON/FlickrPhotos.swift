//
//  FlickrPhotos.swift
//  flickrfrontend
//
//  Created by victor amaro on 22/05/21.
//

import Foundation

public struct FlickrResults: Deserializable {
    public let photos: FlickrPhotos
    public let stat: String

    public init(photos: FlickrPhotos, stat: String) {
        self.photos = photos
        self.stat = stat
    }
}

public struct FlickrPhotos: Deserializable {
    public let page: Int
    public let pages: Int
    public let perpage: Int
    public let total: Int
    public let photo: [FlickrPhoto]

    public init(page: Int, pages: Int, perpage: Int, total: Int, photo: [FlickrPhoto]) {
        self.page = page
        self.pages = pages
        self.perpage = perpage
        self.total = total
        self.photo = photo
    }
}

public class FlickrPhoto: Deserializable {
    public let id: String
    public let title: String
    public let secret: String
    public var url: String?
    
    public init(id: String, title: String, secret: String, url: String?) {
        self.id = id
        self.title = title
        self.secret = secret
        self.url = url
    }
}

public struct FlickrSizesResults: Deserializable {
    public let sizes: FlickrSizes

    public init(sizes: FlickrSizes) {
        self.sizes = sizes
    }
}

public struct FlickrSizes: Deserializable {
    public let size: [FlickrSize]

    public init(size: [FlickrSize]) {
        self.size = size
    }
}

public struct FlickrSize: Deserializable {
    public let label: String
    public let source: String
    public let url: String
    public let width: Int
    public let height: Int

    public init(label: String, source: String, url: String, width: Int, height: Int) {
        self.label = label
        self.source = source
        self.url = url
        self.width = width
        self.height = height
    }
}
