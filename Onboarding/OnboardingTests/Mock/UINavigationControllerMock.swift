//
//  UINavigationControllerMock.swift
//  OnboardingTests
//
//  Created by Victor Amaro on 30/11/21.
//

import UIKit

class UINavigationControllerMock: UINavigationController {
    
    var dismissWasCalled: Bool = false
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissWasCalled = true
        super.dismiss(animated: flag, completion: completion)
    }
    
}

