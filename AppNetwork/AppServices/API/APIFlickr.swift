//
//  CurrencyRouter.swift
//  virtualwallet
//
//  Created by victor-mac on 17/02/18.
//  Copyright © 2018 victor. All rights reserved.
//

import Foundation
import Alamofire

public enum APIFlickr: Router {
    case searchImages(tag: String, page: Int)
    case listSizes(photoId: String)
    
    public var method: HTTPMethod {
        switch self {
        case .searchImages, .listSizes:
            return .get
        }
    }
    
    public  var urlItems: (path: String, parameters: Parameters?) {
        switch self {
        case let .searchImages(tag, page):
            return (path: "", ["method": "flickr.photos.search",
                               "api_key": "f9cc014fa76b098f9e82f1c288379ea1",
                               "tags": tag,
                               "page": page,
                               "format": "json",
                               "nojsoncallback": 1])
            
        case let .listSizes(photoId):
            return (path: "", ["method": "flickr.photos.getSizes",
                               "api_key": "f9cc014fa76b098f9e82f1c288379ea1",
                               "photo_id": photoId,
                               "format": "json",
                               "nojsoncallback": 1])
        }
    }
    
    public var requestDescription: String {
        switch self {
        case .searchImages:
            return  "Search"
        case .listSizes:
            return "List Sizes"
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try BaseRouter.baseAPIUrl.asURL()
        return try self.buildRequest(fromBaseURL: url)
    }
}
