//
//  PhotoSizeModel.swift
//  FlickrEntities
//
//  Created by Victor Amaro on 17/08/21.
//

import Foundation

public protocol PPhotoSizeModel {
    var type: String {get}
    var url: String {get}
}

public struct PhotoSizeModel {
    public var type: String
    public var url: String
    
    public init(entity: PhotoSizeEntity) {
        type = entity.type
        url = entity.url
    }
}

extension PhotoSizeModel: PPhotoSizeModel {}

extension PhotoSizeModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(url)
        hasher.combine(type)
    }
}

extension Array where Element: PPhotoSizeModel {
    public func getPhotoSize(withType type: String) -> PPhotoSizeModel? {
        return self.first { $0.type == type }
    }
}
