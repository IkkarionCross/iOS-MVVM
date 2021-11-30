//
//  PhotoPageEntity+CoreDataProperties.swift
//  FlickrEntities
//
//  Created by victor amaro on 04/06/21.
//
//

import Foundation
import CoreData

extension PhotoPageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoPageEntity> {
        return NSFetchRequest<PhotoPageEntity>(entityName: "PhotoPageEntity")
    }

    @NSManaged public var page: Int32
    @NSManaged public var perPage: Int32
    @NSManaged public var photos: Set<PhotoEntity>
    @NSManaged public var search: SearchResultEntity

}

// MARK: Generated accessors for photos
extension PhotoPageEntity {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: PhotoEntity)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: PhotoEntity)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}

extension PhotoPageEntity : Identifiable {

}
