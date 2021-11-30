//
//  PhotoDAO.swift
//  FlickrEntities
//
//  Created by victor amaro on 22/06/21.
//

import CoreData

public struct PhotoDAO {
    private let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func photo(forId id: String) throws -> PhotoModel? {
        let request: NSFetchRequest<PhotoEntity> = PhotoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        
        guard let photoEntity = try context.fetch(request).first else { return nil }
        
        return PhotoModel(entity: photoEntity)
    }
}
