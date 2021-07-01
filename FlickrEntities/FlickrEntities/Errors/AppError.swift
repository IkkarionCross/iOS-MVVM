//
//  AppError.swift
//  AppPolo1
//
//  Created by Victor Amaro on 17/07/19.
//  Copyright © 2019 Victor Amaro. All rights reserved.
//

import Foundation

public protocol AppError: LocalizedError {
    var title: String {get}
}

extension AppError where Self: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription &&
            rhs.title == lhs.title
    }
}

public enum DefaultError: AppError {
    case unkwonError(title: String)
    
    public var title: String {
        switch self {
        case let .unkwonError(title):
            return title
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case .unkwonError:
            return "Desculpe. Um erro inesperado ocorreu."
        }
    }
}
