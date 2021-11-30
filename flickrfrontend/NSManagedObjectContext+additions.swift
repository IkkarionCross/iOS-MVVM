//
//  NSManagedObjectContext+additions.swift
//  AppPolo1
//
//  Created by Victor Amaro on 13/08/19.
//  Copyright © 2019 Victor Amaro. All rights reserved.
//

import CoreData


extension NSManagedObjectContext {
    
    public func privateContext() -> NSManagedObjectContext {
        let newContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        newContext.parent = self
        
        return newContext
    }
    
    public func saveSync() throws {
        if !self.hasChanges { return }
        try self.save()
        if self.parent != nil {
            self.parent?.performAndWait {
                do {
                    try self.parent?.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
