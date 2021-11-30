//
//  OnboardingScreenFactory.swift
//  Onboarding
//
//  Created by Victor Amaro on 30/11/21.
//

import UIKit

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
