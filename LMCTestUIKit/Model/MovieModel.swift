//
//  MovieModel.swift
//  LMCTestUIKit
//
//  Created by Vladislav Andreev on 21.09.2024.
//

import Foundation
import UIKit

// MARK: структура для парсинга фильмов в таблицах
struct MovieModel: Codable {
    /// ID фильма
    let kinopoiskId: Int
    let imdbId: String?
    /// Название на русском
    let nameRu: String?
    /// Название на английском
    let nameEn: String?
    /// Оригинальное название
    let nameOriginal: String?
    /// Страны
    let countries: [Country]
    /// Жанры
    let genres: [Genre]
    /// Рейтинг кинопоиска
    let ratingKinopoisk: Double?
    let ratingImdb: Double?
    /// Год выпуска
    let year: Int
    /// Тип ( FILM, VIDEO, TV_SERIES, MINI_SERIES, TV_SHOW )
    let type: String
    
    ///Картинка фильма
    let posterUrl: String
    let posterUrlPreview: String
}

// MARK: - Country
struct Country: Codable {
    let country: String
}

// MARK: - Genre
struct Genre: Codable {
    let genre: String
}
