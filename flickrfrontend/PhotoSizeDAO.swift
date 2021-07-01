//
//  PhotoSizeDAO.swift
//  FlickrEntities
//
//  Created by victor amaro on 22/06/21.
//

import CoreData

public struct PhotoSizeDAO {
    private let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func size(forType type: String, andPhotoId photoId: String) throws -> PhotoSizeEntity? {
        let fetchRequest: NSFetchRequest<PhotoSizeEntity> = PhotoSizeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "type == %@ and photo.id == %@", type, photoId)
        
        return try context.fetch(fetchRequest).first
    }
   
    public func save(sizesForPhotoId id: String, fromNeworkResults results: [FlickrSize], completion: (Completion<[PhotoSizeEntity]>)->Void) {
        let privateContext = self.context.privateContext()
        // have to solve this callback hell using combine
        privateContext.performAndWait {
            do {
                let request: NSFetchRequest<PhotoEntity> = PhotoEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", id)
                
                guard let photo = try privateContext.fetch(request).first else {
                    throw DatabaseError.couldNotFind(entity: "photo")
                }
                
                for result in results {
                    let photoSizeEntity: PhotoSizeEntity = PhotoSizeEntity(context: privateContext)
                    photoSizeEntity.type = result.label
                    photoSizeEntity.url = result.source
                    
                    photo.addToSizes(photoSizeEntity)
                }
                
                try privateContext.saveSync()
                
                context.performAndWait {
                    do {
                        guard let photo = try context.fetch(request).first else {
                            return completion(.failure(DatabaseError.couldNotFind(entity: "photo")))
                        }
                        
                        guard let photoSizes = photo.sizes else {
                            return completion(.failure(DatabaseError.couldNotFind(entity: "PhotoSizes")))
                        }
                        
                        completion(.success(Array(photoSizes)))
                    } catch {
                        completion(.failure(DatabaseError.databaseError(error)))
                    }
                }
                
            } catch {
                completion(.failure(DatabaseError.databaseError(error)))
            }
        }
        
        
    }
}
