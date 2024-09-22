//
//  MovieResponse.swift
//  LMCTestUIKit
//
//  Created by Vladislav Andreev on 21.09.2024.
//

import Foundation

struct GenericResponse<T: Codable>: Codable {
    let total: Int
    let totalPages: Int
    let items: [T]
}
