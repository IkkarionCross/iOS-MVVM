//
//  PhotoViewModel.swift
//  flickrfrontend
//
//  Created by Victor Amaro on 24/07/21.
//

import Foundation
import FlickrEntities

struct PhotoViewModel {
    private let photo: PPhotoModel
    
    var id: String {
        return photo.id
    }
    
    var title: String {
        return photo.title
    }
    
    var largeSquareImageUrl: String? {
        return photo.sizes.first { $0.type ==  "Large Square" }?.url
    }
    
    
    init(photo: PPhotoModel) {
        self.photo = photo
    }
    
}
