//
//  SearchDAO.swift
//  FlickrEntities
//
//  Created by victor amaro on 04/06/21.
//

import Foundation
import CoreData

public struct SearchDAO {
    private let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func lastSearch(withText text: String) throws -> SearchResultEntity? {
        let fetchRequest: NSFetchRequest<SearchResultEntity> = SearchResultEntity.fetchRequest()
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "createdAt", ascending: false)]
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "searchText == %@", text)
        
        return try self.context.fetch(fetchRequest).first
    }
    
    public func page(forSearchText text: String, andPage pageNumber: Int) throws -> PhotoPageEntity? {
        let fetchRequest: NSFetchRequest<PhotoPageEntity> = PhotoPageEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "search.searchText == %@ and page == %d", text, pageNumber)
        fetchRequest.fetchLimit = 1
        
        return try self.context.fetch(fetchRequest).first
    }
    
    public func saveSearch(withText text: String, andPage page: Int,
                           fromNetworkResults results: FlickrResults,
                           completion: (Completion<PhotoPageEntity>)->Void)  {
        let pContext = context.privateContext()
        pContext.performAndWait {
            do {
                let searchEntity: SearchResultEntity = SearchResultEntity(context: pContext)
                searchEntity.searchText = text
                searchEntity.createdAt = Date()
                
                let photoPage: PhotoPageEntity = PhotoPageEntity(context: pContext)
                photoPage.page = Int32(page)
                photoPage.perPage = Int32(results.photos.perpage)
                
                searchEntity.addToPages(photoPage)
                
                save(photos: results.photos.photo, inPhotoPage: photoPage, withContext: pContext)
                
                try pContext.saveSync()
                
                context.performAndWait {
                    do {
                        guard let lastSearch = try self.lastSearch(withText: text, withContext: context) else {
                            return completion(.failure(DatabaseError.couldNotFind(entity: "Search with text: \(text)")))
                        }
                        
                        guard let photoPage = lastSearch.pages.first else {
                            return completion(.failure(DatabaseError.couldNotFind(entity: "First Photo page")))
                        }
                        completion(.success(photoPage))
                    }
                    catch {
                        completion(.failure(DatabaseError.databaseError(error)))
                    }
                }
            }
            catch {
                completion(.failure(DatabaseError.databaseError(error)))
            }
            
        }
        
    }
    
    public func savePageInLastSearch(withText text: String, andPage page: Int, fromNetworkResults results: FlickrResults, completion: (Completion<PhotoPageEntity>)->Void) {
        let privateContext = context.privateContext()
        
        privateContext.performAndWait {
            do {
                guard let lastSearch = try self.lastSearch(withText: text, withContext: privateContext) else {
                    return completion(.failure(DatabaseError.couldNotFind(entity: "Search with text: \(text)")))
                }
                
                let photoPage: PhotoPageEntity = PhotoPageEntity(context: privateContext)
                photoPage.page = Int32(page)
                photoPage.perPage = Int32(results.photos.perpage)
                
                lastSearch.addToPages(photoPage)
                
                save(photos: results.photos.photo, inPhotoPage: photoPage, withContext: privateContext)
                
                try privateContext.saveSync()
                
                context.performAndWait {
                    do {
                        guard let lastSearch = try self.lastSearch(withText: text, withContext: context) else {
                            return completion(.failure(DatabaseError.couldNotFind(entity: "Search with text: \(text)")))
                        }
                        guard let photoPage = lastSearch.pages.first(where: { $0.page == page }) else {
                            return completion(.failure(DefaultError.unkwonError(title: "Without page")))
                        }
                        completion(.success(photoPage))
                    } catch {
                        completion(.failure(DatabaseError.databaseError(error)))
                    }
                }
            } catch {
                completion(.failure(DatabaseError.databaseError(error)))
            }
        }
        
    }
    
    private func save(photos: [FlickrPhoto], inPhotoPage photoPage: PhotoPageEntity, withContext pContext: NSManagedObjectContext) {
        for jsonPhoto in photos {
            let photo: PhotoEntity = PhotoEntity(context: pContext)
            photo.id = jsonPhoto.id
            photo.title = jsonPhoto.title
            
            photoPage.addToPhotos(photo)
        }
    }
    
    private func lastSearch(withText text: String, withContext pContext: NSManagedObjectContext) throws -> SearchResultEntity? {
        let fetchRequest: NSFetchRequest<SearchResultEntity> = SearchResultEntity.fetchRequest()
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "createdAt", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "searchText == %@", text)
        fetchRequest.fetchLimit = 1

        return try pContext.fetch(fetchRequest).first
    }
    
    private func lastSearch(withText text: String, completion: (Completion<SearchResultEntity?>)->Void) {
        context.performAndWait {
            let fetchRequest: NSFetchRequest<SearchResultEntity> = SearchResultEntity.fetchRequest()
            fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "createdAt", ascending: false)]
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "searchText == %@", text)
            
            do {
                let lastSearch = try self.context.fetch(fetchRequest).first
                
                completion(.success(lastSearch))
            } catch {
                completion(.failure(DatabaseError.databaseError(error)))
            }
        }
    }
}
