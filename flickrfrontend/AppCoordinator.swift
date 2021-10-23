//
//  AppCoordinator.swift
//  flickrfrontend
//
//  Created by Victor Amaro on 10/10/21.
//

import UIKit
import CoreData
import AppServices
import FlickrEntities
import LoginModule
import Coordinator

class AppCoordinator: Coordinator {
    
    let context: NSManagedObjectContext
    let navController: UINavigationController
    
    init(context: NSManagedObjectContext, navController: UINavigationController) {
        self.context = context
        self.navController = navController
    }
    
    func start() {
    }
    
    
}
