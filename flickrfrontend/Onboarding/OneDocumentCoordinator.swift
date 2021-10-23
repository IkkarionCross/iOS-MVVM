//
//  OneDocumentCoordinator.swift
//  flickrfrontend
//
//  Created by Victor Amaro on 23/10/21.
//

import UIKit
import CoreData
import Coordinator

public class DocumentCoordinator: PDocumentCoordinator {
    let context: NSManagedObjectContext
    let navController: UINavigationController
    
    init(context: NSManagedObjectContext, navController: UINavigationController) {
        self.context = context
        self.navController = navController
    }
    
    public func nextScreen() {
        
    }
    
    public func start() {
        
    }
}
