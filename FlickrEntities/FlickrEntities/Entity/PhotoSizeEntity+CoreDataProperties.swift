//
//  PhotoSizeEntity+CoreDataProperties.swift
//  FlickrEntities
//
//  Created by victor amaro on 04/06/21.
//
//

import Foundation
import CoreData

extension PhotoSizeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoSizeEntity> {
        return NSFetchRequest<PhotoSizeEntity>(entityName: "PhotoSizeEntity")
    }

    @NSManaged public var type: String
    @NSManaged public var url: String
    @NSManaged public var photo: PhotoEntity
    

}
