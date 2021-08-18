//
//  PhotoEntity+CoreDataProperties.swift
//  FlickrEntities
//
//  Created by victor amaro on 04/06/21.
//
//

import Foundation
import CoreData

extension PhotoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoEntity> {
        return NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
    }

    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var sizes: Set<PhotoSizeEntity>?
    @NSManaged public var page: PhotoPageEntity

}

// MARK: Generated accessors for sizes
extension PhotoEntity {

    @objc(addSizesObject:)
    @NSManaged public func addToSizes(_ value: PhotoSizeEntity)

    @objc(removeSizesObject:)
    @NSManaged public func removeFromSizes(_ value: PhotoSizeEntity)

    @objc(addSizes:)
    @NSManaged public func addToSizes(_ values: NSSet)

    @objc(removeSizes:)
    @NSManaged public func removeFromSizes(_ values: NSSet)

}

extension PhotoEntity : Identifiable {

}
