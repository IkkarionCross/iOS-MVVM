//
//  PLoginCoordinator.swift
//  Coordinator
//
//  Created by Victor Amaro on 20/10/21.
//

import Foundation

public protocol Dependencies {}

public protocol PDocumentCoordinator: Coordinator {
    func nextScreen()
}

public protocol PGalleryCoordinator: Coordinator {
    associatedtype T: Dependencies
    func showDetail(forDependency photo: T)
}

public protocol POnBoardinCoordinator: Coordinator {
    func nextScreen()
}

public protocol PLoginCoordinator: Coordinator {
    func registerFlow()
    func loginSuccessful()
}

public protocol PAddressCoordinator: Coordinator {
    func back()
    func nextScreen()
}
