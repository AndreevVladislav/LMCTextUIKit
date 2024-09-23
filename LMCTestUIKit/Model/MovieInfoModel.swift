//
//  MovieInfoModel.swift
//  LMCTestUIKit
//
//  Created by Vladislav Andreev on 21.09.2024.
//

import Foundation

// MARK: - модель информации о фильме
struct MovieInfoModel: Codable {
    let kinopoiskId: Int
    
    /// Название
    let nameOriginal: String?
    
    /// Картинка
    let coverUrl: String?
    
    /// Рейтинг Кинопоиск
    let ratingKinopoisk: Double?
    
    let webUrl: String?
    /// Год фильма
    let year: Int?
    /// Описание фильма
    let description: String?
    /// Страны
    let countries: [Country]
    /// Жанры
    let genres: [Genre]
    /// Год премьеры
    let startYear: Int?
    /// Год последнего сезона
    let endYear: Int?
}
