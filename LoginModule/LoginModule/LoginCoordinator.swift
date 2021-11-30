//
//  LoginCoordinator.swift
//  LoginModule
//
//  Created by Victor Amaro on 11/10/21.
//

import UIKit
import Coordinator
import CoreData


public enum LoginFlow: String, AppFlow {
    case login = "login", onboarding = "register"
}

public class LoginCoordinator: BaseCoordinator<LoginFlow> {
    private var navController: UINavigationController
    public let loginNavController: UINavigationController
    
    public init(context: NSManagedObjectContext, navController: UINavigationController) {
        self.navController = navController
        self.loginNavController = UINavigationController()
        super.init()
    }
    
    public override func start() {
        let loginController: LoginViewController = LoginViewController()
        loginController.coordinator = self
        loginController.modalPresentationStyle = .fullScreen
        loginNavController.modalPresentationStyle = .fullScreen
        loginNavController.pushViewController(loginController, animated: true)
        
        DispatchQueue.main.async { [unowned self] in
            self.navController.present(self.loginNavController, animated: false, completion: nil)
        }
    }
    
    public func registerFlow() {
        coordinator(forFlow: .onboarding)?.start()
    }
    
    public func loginSuccessful() {
        navController.topViewController?.dismiss(animated: true, completion: nil)
    }
}
