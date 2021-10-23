//
//  CoordinatableViewController.swift
//  Coordinator
//
//  Created by Victor Amaro on 20/10/21.
//

import UIKit

public protocol CoordinatableViewController {
    associatedtype aCoordinator: Coordinator
    var coordinator: aCoordinator? {get set}
}
