//
//  Route.swift
//  AppPolo1
//
//  Created by Victor Amaro on 17/07/19.
//  Copyright © 2019 Victor Amaro. All rights reserved.
//

import Foundation
import Alamofire

public protocol Router: URLRequestConvertible {
    var urlItems: (path: String, parameters: Parameters?) {get}
    var method: HTTPMethod {get}
    var requestDescription: String {get}
}

public extension Router {
    func buildRequest(fromBaseURL baseURL: URL) throws -> URLRequest {
        let urlItems = self.urlItems
        
        let url = baseURL.appendingPathComponent(urlItems.path)
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method.rawValue
        
        return try URLEncoding.default.encode(urlRequest, with: urlItems.parameters)
    }
}
