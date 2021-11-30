//
//  Service.swift
//  AppServices
//
//  Created by victor amaro on 04/06/21.
//

import Foundation
import FlickrEntities

public protocol DataService {
    associatedtype DataType: Deserializable
}
