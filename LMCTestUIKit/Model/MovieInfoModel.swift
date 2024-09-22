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
    let kinopoiskHDId: String?
    let imdbId: String?
    let nameRu: String?
    let nameEn: String?
    /// Название
    let nameOriginal: String?
    let posterUrl: String?
    let posterUrlPreview: String?
    /// Картинка
    let coverUrl: String?
    let logoUrl: String?
    let reviewsCount: Int?
    let ratingGoodReview: Double?
    let ratingGoodReviewVoteCount: Int?
    /// Рейтинг Кинопоиск
    let ratingKinopoisk: Double?
    let ratingKinopoiskVoteCount: Int?
    let ratingImdb: Double?
    let ratingImdbVoteCount: Int?
    let ratingFilmCritics: Double?
    let ratingFilmCriticsVoteCount: Int?
    let ratingAwait: Double?
    let ratingAwaitCount: Int?
    let ratingRfCritics: Double?
    let ratingRfCriticsVoteCount: Int?
    let webUrl: String?
    /// Год фильма
    let year: Int?
    let filmLength: Int?
    let slogan: String?
    /// Описание фильма
    let description: String?
    let shortDescription: String?
    let editorAnnotation: String?
    let isTicketsAvailable: Bool?
    let productionStatus: String?
    let type: String?
    let ratingMpaa: String?
    let ratingAgeLimits: String?
    /// Страны
    let countries: [Country]
    /// Жанры
    let genres: [Genre]
    /// Год премьеры
    let startYear: Int?
    /// Год последнего сезона
    let endYear: Int?
    let serial: Bool?
    let shortFilm: Bool?
    let completed: Bool?
    let hasImax: Bool?
    let has3D: Bool?
    let lastSync: String?
}
