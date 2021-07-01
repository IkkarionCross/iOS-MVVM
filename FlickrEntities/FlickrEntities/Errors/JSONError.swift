//
//  JSONError.swift
//  AppPolo1
//
//  Created by Victor Amaro on 08/08/19.
//  Copyright © 2019 Victor Amaro. All rights reserved.
//

import Foundation

public enum JSONError: AppError, Equatable {
    case parseError
    
    public var title: String {
        switch self {
        case .parseError:
            return "Erro ao tentar ler informações"
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case .parseError:
            return "O servidor respondeu com informações que este aplicativo não consegue ler."
        }
    }
}
