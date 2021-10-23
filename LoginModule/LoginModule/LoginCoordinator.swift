//
//  LoginCoordinator.swift
//  LoginModule
//
//  Created by Victor Amaro on 11/10/21.
//

import UIKit
import Coordinator
import CoreData

public class LoginCoordinator: PLoginCoordinator {
    public var onboardingCoordinator: Coordinator
    
    private var navController: UINavigationController
    
    public init(context: NSManagedObjectContext, navController: UINavigationController,  onboardingCoordinator: Coordinator) {
        self.navController = navController
        self.onboardingCoordinator = onboardingCoordinator
    }
    
    public func start() {
        let loginController: LoginViewController = LoginViewController()
        loginController.coordinator = self
        loginController.modalPresentationStyle = .fullScreen
        navController.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async { [weak self] in
            self?.navController.present(loginController, animated: false, completion: nil)
        }
    }
    
    public func registerFlow() {
        onboardingCoordinator.start()
    }
    
    public func loginSuccessful() {
        navController.topViewController?.dismiss(animated: true, completion: nil)
    }
}
