//
//  SearchResultModel.swift
//  FlickrEntities
//
//  Created by Victor Amaro on 17/08/21.
//

import Foundation
public protocol PSearchResultModel {
    var createdAt: Date {get }
    var searchText: String {get }
    var pages: [PPhotoPageModel] {get }
}

public struct SearchResultModel {
    public var createdAt: Date
    public var searchText: String
    public var pages: [PPhotoPageModel]
    
    public init(entity: SearchResultEntity) {
        createdAt = entity.createdAt
        searchText = entity.searchText
        pages = []
        entity.pages.forEach{ pageEntity in
            pages.append(PhotoPageModel(entity: pageEntity))
        }
    }
}

extension SearchResultModel: PSearchResultModel {}
