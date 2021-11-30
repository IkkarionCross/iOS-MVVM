//
//  Completion.swift
//  FlickrEntities
//
//  Created by victor amaro on 26/05/21.
//

import Foundation

public enum Completion<T> {
    case success(T)
    case failure(AppError)
}
