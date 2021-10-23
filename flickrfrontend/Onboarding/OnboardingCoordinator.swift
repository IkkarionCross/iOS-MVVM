//
//  OnboardingCoordinator.swift
//  flickrfrontend
//
//  Created by Victor Amaro on 23/10/21.
//

import UIKit
import CoreData
import Coordinator

public class OnBoardingCoordinator: POnBoardinCoordinator {
    public var oneDocumentCoordinator: PDocumentCoordinator
    let context: NSManagedObjectContext
    let navController: UINavigationController
    
    init(context: NSManagedObjectContext, navController: UINavigationController, oneDocumentCoordinator: PDocumentCoordinator) {
        self.context = context
        self.navController = navController
        self.oneDocumentCoordinator = oneDocumentCoordinator
    }
    
    public func nextScreen() {
        
    }
    
    public func start() {
        
    }
}
