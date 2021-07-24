//
//  PhotoViewModel.swift
//  flickrfrontend
//
//  Created by Victor Amaro on 24/07/21.
//

import Foundation
import FlickrEntities

struct PhotoViewModel {
    private let photo: PhotoEntity
    
    var id: String {
        return photo.id
    }
    
    var title: String {
        return photo.title
    }
    
    var largeSquareImageUrl: String? {
        return photo.sizes?.getPhotoSize(withType: "Large Square")?.url
    }
    
    
    init(photo: PhotoEntity) {
        self.photo = photo
    }
    
}
