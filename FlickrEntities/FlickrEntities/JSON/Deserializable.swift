//
//  Deserializable.swift
//  AppPolo1
//
//  Created by Victor Amaro on 08/08/19.
//  Copyright © 2019 Victor Amaro. All rights reserved.
//

import Foundation

public protocol Deserializable: Codable {}

extension Deserializable {
    public static func dateDecodingStrategy() -> JSONDecoder.DateDecodingStrategy {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return .formatted(formatter)
    }
    
    public static func desserialize(json: [String: Any]) throws -> Self? {
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: [])
        let decoder: JSONDecoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy()
        return try decoder.decode(Self.self, from: data)
    }
    
    public static func desserialize(jsonText: String) throws -> Self? {
        guard let jsonData = jsonText.data(using: .utf8) else { return nil }
        let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: [])
        let decoder: JSONDecoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy()
        return try decoder.decode(Self.self, from: data)
    }
}
