//
//  SearchModel.swift
//  LMCTestUIKit
//
//  Created by Vladislav Andreev on 19.09.2024.
//

import Foundation
import UIKit

// MARK: - структура для поиска фильмов
class SearchModel {
    
    var keyword: String = ""
    var year: Int = 0
    
    init(keyword: String, year: Int) {
        self.keyword = keyword
        self.year = year
    }
}
