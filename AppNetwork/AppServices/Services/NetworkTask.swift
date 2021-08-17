//
//  NetworkTask.swift
//  AppServices
//
//  Created by Victor Amaro on 15/08/21.
//

import Foundation
import Alamofire

public class NetworkTask {
    
    private weak var request: DataRequest?
    
    init(request: DataRequest) {
        self.request = request
    }
    
    public func cancel() {
        if request != nil {
            self.request?.cancel()
        }
    }
}
