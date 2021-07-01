//
//  NetworkService.swift
//  virtualwallet
//
//  Created by victor-mac on 17/02/18.
//  Copyright © 2018 victor. All rights reserved.
//

import Foundation
import Alamofire
import FlickrEntities

public class RESTService<T: Deserializable>: NetworkService {
    public typealias DataType = T
    
    internal func retrieveData(request: Router,
                      queue: DispatchQueue = DispatchQueue.global(),
                      completion: @escaping (_ result: Completion<DataType>) -> Void) throws {
        try AF.request(request.asURLRequest())
            .validate(statusCode: 200...299)
            .responseJSON(queue: queue, options: JSONSerialization.ReadingOptions.allowFragments) { response in
                let requestDescription = request.requestDescription
                switch response.result {
                case .success:
                    if let JSONValue = response.value as? [String: Any] {
                        do {
                            if let jsonObject = try DataType.desserialize(json: JSONValue) {
                                completion(Completion.success(jsonObject))
                            } else { completion(Completion.failure(NetworkError.invalidDataReceived(requestDescription: requestDescription)))
                            }
                        } catch {
                            completion(Completion.failure(JSONError.parseError))
                        }
                    } else {
                        completion(Completion.failure(
                            NetworkError.invalidDataReceived(requestDescription: requestDescription)))
                    }
                case .failure:
                    let statusCode: String
                    if let code = response.response?.statusCode {
                        statusCode = String(code)
                    } else {
                        statusCode = ""
                    }
                    let message = response.error?.localizedDescription ?? ""
                    let serverError = NetworkError.serverError(statusCode: statusCode, message: message)
                    completion(Completion.failure(serverError))
                }
        }
    }
    
}
