//
//  Coordinator.swift
//  Coordinator
//
//  Created by Victor Amaro on 20/10/21.
//

import UIKit

public protocol AppFlow: Hashable, RawRepresentable {
    var rawValue: String {get}
}

public protocol CooordinatorFlow {
    func withNavController(controller: UINavigationController)
}

public protocol Coordinator {
    func start()
}

public protocol FlowCoordinator: AnyObject, Coordinator {
    associatedtype Flow: AppFlow
    func register(forFlow flow: Flow, withCoordinator coordinator: Coordinator)
    func coordinator(forFlow flow: Flow) -> Coordinator?
}


open class BaseCoordinator<T: AppFlow>: FlowCoordinator {
    public typealias Flow = T
    private(set) var flows: [Flow: Coordinator] = [:]
    
    public init() {}
    
    public func register(forFlow flow: Flow, withCoordinator coordinator: Coordinator) {
        flows[flow] = coordinator
    }
    
    public func coordinator(forFlow flow: Flow) -> Coordinator? {
        return flows[flow]
    }
    
    open func start() {}
}
