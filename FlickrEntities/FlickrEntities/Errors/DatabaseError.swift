//
//  DatabaseError.swift
//  FlickrEntities
//
//  Created by victor amaro on 26/05/21.
//

import Foundation

public enum DatabaseError: AppError, Equatable {
    case databaseError(Error)
    case couldNotFind(entity: String)

    public var title: String {
        switch self {
        case .databaseError:
            return "Erro ao tentar interagir com o banco de dados."
        case .couldNotFind:
            return "Registro não encontrado"
        }
    }

    public var errorDescription: String? {
        switch self {
        case let .databaseError(error):
            return "Um erro ocorreu ao tentar interagir com o banco de dados: \(error.localizedDescription)"
        case let .couldNotFind(entity):
            return "Não foi possível encontrar a entidade \(entity)"
        }
    }
}

