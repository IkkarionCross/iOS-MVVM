//
//  PhotoPageModel.swift
//  FlickrEntities
//
//  Created by Victor Amaro on 17/08/21.
//

import Foundation
public protocol PPhotoPageModel {
    var page: Int32 {get}
    var perPage: Int32 {get}
    var photos: [PPhotoModel] {get}
}

public struct PhotoPageModel {
    public var page: Int32
    public var perPage: Int32
    public var photos: [PPhotoModel]
    
    public init(entity: PhotoPageEntity) {
        self.page = entity.page
        self.perPage = entity.perPage
        self.photos = []
        entity.photos.forEach { photoEntity in
            photos.append(PhotoModel(entity: photoEntity))
        }
        
    }
}

extension PhotoPageModel: PPhotoPageModel {}
extension PhotoPageModel: Hashable {
    public static func == (lhs: PhotoPageModel, rhs: PhotoPageModel) -> Bool {
        return lhs.page == rhs.page
            
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(page)
        hasher.combine(photos.count)
    }
}
