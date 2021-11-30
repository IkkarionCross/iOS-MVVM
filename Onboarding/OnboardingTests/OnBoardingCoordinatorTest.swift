//
//  OnBoardingCoordinatorTest.swift
//  OnboardingTests
//
//  Created by Victor Amaro on 30/11/21.
//

import XCTest
@testable import Onboarding

class OnBoardingCoordinatorTest: XCTestCase {
    var sut: OnBoardingCoordinator!
    var navController: UINavigationControllerMock!
    
    override func setUpWithError() throws {
        navController = UINavigationControllerMock()
        sut = OnBoardingCoordinator(navController: navController)
    }
    
    override func tearDownWithError() throws {
        navController = nil
        sut = nil
    }

    func testShouldStartInNameScreen() throws {
        
        XCTAssertEqual(sut.onboardingScreen, .none)
        
        sut.start()
        
        XCTAssertEqual(sut.onboardingScreen, .name)
    }
    
    func testShouldFollowScreenRightOrder() throws {
        
        sut.start()
        
        XCTAssertEqual(sut.onboardingScreen, .name)
        
        sut.nextScreen()
        
        XCTAssertEqual(sut.onboardingScreen, .birthDate)
        
        sut.nextScreen()
        
        XCTAssertEqual(sut.onboardingScreen, .adressOption)
    }
    
    func testShouldGoBackToPreviusScreen() throws {
        let expectedAmountViewControllers = 1
        
        sut.start()
        
        XCTAssertEqual(sut.onboardingScreen, .name)
        
        sut.nextScreen()
        
        XCTAssertEqual(sut.onboardingScreen, .birthDate)
        
        sut.back()
        
        XCTAssertEqual(sut.onboardingScreen, .name)
        XCTAssertEqual(navController.viewControllers.count, expectedAmountViewControllers)
    }
    
    func testShouldDismissWhenInLastScreen() throws {
        sut.start()
        sut.nextScreen()
        sut.nextScreen()
        sut.nextScreen()
        sut.nextScreen()
        sut.nextScreen()
        sut.nextScreen()
        
        XCTAssertEqual(sut.onboardingScreen, .oneDocument)
        
        sut.nextScreen()
        
        XCTAssertTrue(navController.dismissWasCalled)
    }
    
    func testShouldDismiss_WhenItCantMakeBackAction() throws {
        sut.start()
        
        XCTAssertEqual(sut.onboardingScreen, .name)
        
        sut.back()
        sut.back()
        
        XCTAssertEqual(sut.onboardingScreen, .none)
    }

}
