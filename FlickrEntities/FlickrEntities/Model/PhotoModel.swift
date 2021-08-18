//
//  PhotoModel.swift
//  FlickrEntities
//
//  Created by Victor Amaro on 17/08/21.
//

import Foundation
public protocol PPhotoModel {
    var id: String {get}
    var title: String {get}
    var sizes: [PPhotoSizeModel] {get}
}

public struct PhotoModel {
    public var id: String
    public var title: String
    public var sizes: [PPhotoSizeModel]
    
    public init(entity: PhotoEntity) {
        self.id = entity.id
        self.title = entity.title
        self.sizes = entity.sizes?.map({ sizeEntity in
            return PhotoSizeModel(entity: sizeEntity)
        }) ?? []
    }
}

extension PhotoModel: PPhotoModel {}
extension PhotoModel: Hashable {
    public static func == (lhs: PhotoModel, rhs: PhotoModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
