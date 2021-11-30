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
    
    private let navController: UINavigationController
    
    private(set) var onboardingScreen: OnboardingScreens = .none
    
    public init(navController: UINavigationController) {
        self.navController = navController
    }
    
    public func start() {
        nextScreen()
    }
    
    public func nextScreen() {
        guard onboardingScreen != .oneDocument else {
            self.navController.dismiss(animated: true, completion: nil)
            return
        }
        
        guard let next = screen(adding: 1) else { return }
        goToScreen(screen: next)
        print("Next Screen: \(next)")
    }
    
    public func back() {
        guard let previous = screen(adding: -1) else { return }
        onboardingScreen = previous
        print("Previous Screen: \(previous)")
    }
    
    private func screen(adding number: Int) -> OnboardingScreens? {
        return OnboardingScreens(rawValue: onboardingScreen.rawValue + number)
    }
    
    private func goToScreen(screen: OnboardingScreens) {
        guard let viewController = OnboardingScreenFactory.create(screen: screen, coordinator: self) else { return }
        onboardingScreen = screen
        self.navController.pushViewController(viewController, animated: true)
    }
}

extension OnBoardingCoordinator: PDecisionDelegate {
    func decision1() {
        nextScreen()
    }
    
    func decision2() {
        goToScreen(screen: .oneDocument)
    }
}
