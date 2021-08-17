//
//  Service.swift
//  AppPolo1
//
//  Created by Victor Amaro on 17/07/19.
//  Copyright © 2019 Victor Amaro. All rights reserved.
//

import Foundation
import Alamofire
import FlickrEntities

protocol NetworkService: DataService {
    func retrieveData(request: Router, queue: DispatchQueue, completion: @escaping (_ result: Completion<DataType>) -> Void) throws -> NetworkTask
}
