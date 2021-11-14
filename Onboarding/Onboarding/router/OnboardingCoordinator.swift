//
//  OnboardingCoordinator.swift
//  flickrfrontend
//
//  Created by Victor Amaro on 23/10/21.
//

import UIKit
import CoreData
import Coordinator

enum OnboardingScreens: Int {
    case none, name, birthDate, adressOption, street, numberAndComplement, oneDocument
}

final class OnboardingScreenFactory {
    static func create(screen: OnboardingScreens, coordinator: OnBoardingCoordinator) -> UIViewController? {
        switch screen {
        case .none:
            return nil
        case .name:
            let viewController =  OnboardingViewController(viewModel: OnboardingViewModel(placeHolder: "Your Name", actionButtonTitle: "Continue"))
            viewController.coordinator = coordinator
            return viewController
        case .birthDate:
            let viewController = OnboardingViewController(viewModel: OnboardingViewModel(placeHolder: "Your Birth Date", actionButtonTitle: "Continue"))
            viewController.coordinator = coordinator
            return viewController
        case .adressOption:
            let viewController = OnboardingDecisionViewController(viewModel: OnboardingDecisionViewModel(decision1Title: "Give an Adress", decision2Title: "Do not give adress"))
            viewController.coordinator = coordinator
            viewController.decisionDelegate = coordinator
            return viewController
        case .oneDocument:
            let viewController = OnboardingViewController(viewModel: OnboardingViewModel(placeHolder: "One document number...", actionButtonTitle: "Continue"))
            viewController.coordinator = coordinator
            return viewController
        case .street:
            let viewController = OnboardingViewController(viewModel: OnboardingViewModel(placeHolder: "Street name", actionButtonTitle: "Continue"))
            viewController.coordinator = coordinator
            return viewController
        case .numberAndComplement:
            let viewController = OnboardingViewController(viewModel: OnboardingViewModel(placeHolder: "Number and Complement", actionButtonTitle: "Continue"))
            viewController.coordinator = coordinator
            return viewController
        }
    }
}

public class OnBoardingCoordinator: POnBoardinCoordinator {
    
    private let context: NSManagedObjectContext
    private let navController: UINavigationController
    
    private var onboardingScreen: OnboardingScreens = .none
    
    public init(context: NSManagedObjectContext, navController: UINavigationController) {
        self.context = context
        self.navController = navController
    }
    
    private func screen(forDirection direction: Int) -> OnboardingScreens? {
        return OnboardingScreens(rawValue: onboardingScreen.rawValue + direction)
    }
    
    private func goToScreen(screen: OnboardingScreens) {
        guard let viewController = OnboardingScreenFactory.create(screen: screen, coordinator: self) else { return }
        onboardingScreen = screen
        self.navController.pushViewController(viewController, animated: true)
    }
    
    public func start() {
        nextScreen()
    }
    
    public func nextScreen() {
        guard onboardingScreen != .oneDocument else {
            self.navController.dismiss(animated: true, completion: nil)
            return
        }
        
        guard let next = screen(forDirection: 1) else { return }
        goToScreen(screen: next)
        print("Next Screen: \(next)")
    }
    
    public func back() {
        guard let previous = screen(forDirection: -1) else { return }
        onboardingScreen = previous
        print("Previous Screen: \(previous)")
    }
    
    public func adressFlow() {
         print("Addres flow")
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
