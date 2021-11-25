//
//  SearchResultEntity+CoreDataProperties.swift
//  FlickrEntities
//
//  Created by Victor Amaro on 24/11/21.
//
//

import Foundation
import CoreData


extension SearchResultEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchResultEntity> {
        return NSFetchRequest<SearchResultEntity>(entityName: "SearchResultEntity")
    }

    @NSManaged public var createdAt: Date
    @NSManaged public var searchText: String
    @NSManaged public var remotePagesCount: Int32
    @NSManaged public var pages: Set<PhotoPageEntity>

}

// MARK: Generated accessors for pages
extension SearchResultEntity {

    @objc(addPagesObject:)
    @NSManaged public func addToPages(_ value: PhotoPageEntity)

    @objc(removePagesObject:)
    @NSManaged public func removeFromPages(_ value: PhotoPageEntity)

    @objc(addPages:)
    @NSManaged public func addToPages(_ values: NSSet)

    @objc(removePages:)
    @NSManaged public func removeFromPages(_ values: NSSet)

}

extension SearchResultEntity : Identifiable {

}
