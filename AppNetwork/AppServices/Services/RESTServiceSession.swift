////
////  NetworkService.swift
////  virtualwallet
////
////  Created by victor-mac on 08/08/2021.
////  Copyright © 2018 victor. All rights reserved.
////
//
//import Foundation
//import FlickrEntities
//
//public class RESTServiceSession<T: Deserializable>: NetworkService {
//    public typealias DataType = T
//    var dataTask: URLSessionDataTask?
//    
//    internal func retrieveData(request: Router,
//                      queue: DispatchQueue = DispatchQueue.global(),
//                      completion: @escaping (_ result: Completion<DataType>) -> Void) throws {
//        dataTask = try URLSession.shared.dataTask(
//            with: request.asURLRequest(),
//            completionHandler: { [weak self] rawData, response, error in
//                defer {
//                      self?.dataTask = nil
//                }
//                if let taskError = error {
//                    completion(.failure(NetworkError.clientError(message: taskError.localizedDescription)))
//                    return
//                }
//                
//                guard let response = response as? HTTPURLResponse else {
//                    completion(.failure(NetworkError.serverError(statusCode: "500", message: "")))
//                    return
//                }
//                
//                if !(200...299).contains(response.statusCode)  {
//                    completion(.failure(NetworkError.serverError(statusCode: "\(response.statusCode)", message: "")))
//                    return;
//                }
//                
//                do {
//                    guard let jsonData = rawData,
//                          let JSONValue = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] else {
//                        return completion(Completion.failure(
//                                            NetworkError.invalidDataReceived(requestDescription: "request")))
//                    }
//                    if let jsonObject = try DataType.desserialize(json: JSONValue) {
//                        return completion(Completion.success(jsonObject))
//                    } else {
//                        completion(Completion.failure(NetworkError.invalidDataReceived(requestDescription: "")))
//                    }
//                } catch {
//                    completion(Completion.failure(JSONError.parseError))
//                }
//                
//        })
//        dataTask?.resume()
//    }
//    
//}
