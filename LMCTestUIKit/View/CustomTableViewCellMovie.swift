//
//  CustomTableViewCellMovie.swift
//  LMCTestUIKit
//
//  Created by Vladislav Andreev on 19.09.2024.
//

import Foundation
import UIKit

//MARK: ячейка для таблицы с фильмами
class CustomTableViewCellMovie: UITableViewCell {
    
    /// картинка
    var image: UIImageView! = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: 140).isActive = true
        image.heightAnchor.constraint(equalToConstant: 140).isActive = true
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    /// Название фильма
    var nameLable: UILabel! = {
        let text = UILabel()
        text.textColor = UIColor.white
        text.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.numberOfLines = 1
        return text
    }()
    
    /// Жанр фильма
    var genreLable: UILabel! = {
        let text = UILabel()
        text.textColor = UIColor.lightGray
        text.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.numberOfLines = 1
        return text
    }()
    
    /// Год и страна фильма
    var yearCountryLable: UILabel! = {
        let text = UILabel()
        text.textColor = UIColor.lightGray
        text.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.numberOfLines = 1
        return text
    }()
    
    /// Рейтинг фильма
    var ratingyLable: UILabel! = {
        let text = UILabel()
        text.textColor = Constants.Colors.color_neonBlue
        text.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.numberOfLines = 1
        text.textAlignment = .right
        return text
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(image)
        addSubview(nameLable)
        addSubview(genreLable)
        addSubview(ratingyLable)
        addSubview(yearCountryLable)
        
        
        setConstrains()
        
    }
    
    //MARK: констреинты
    func setConstrains() {
        NSLayoutConstraint.activate([
            
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            nameLable.topAnchor.constraint(equalTo: image.topAnchor),
            nameLable.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            nameLable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            genreLable.leadingAnchor.constraint(equalTo: nameLable.leadingAnchor),
            genreLable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            genreLable.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 15),
            
            ratingyLable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            ratingyLable.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            yearCountryLable.leadingAnchor.constraint(equalTo: nameLable.leadingAnchor),
            yearCountryLable.topAnchor.constraint(equalTo: genreLable.bottomAnchor, constant: 15),
            yearCountryLable.trailingAnchor.constraint(equalTo: ratingyLable.leadingAnchor, constant: -10),
            
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

