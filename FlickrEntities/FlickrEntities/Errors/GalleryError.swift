//
//  GalleryError.swift
//  FlickrEntities
//
//  Created by victor amaro on 27/05/21.
//

import Foundation


public enum GalleryError: AppError, Equatable {
    case photoNotFound

    public var title: String {
        switch self {
        case .photoNotFound:
            return "Uma foto não foi encontrada na lista de fotos carregadas"
        }
    }

    public var errorDescription: String? {
        switch self {
        case .photoNotFound:
            return "Uma foto não foi encontrada na lista de fotos carregadas."
        }
    }
}

