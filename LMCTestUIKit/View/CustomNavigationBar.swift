//
//  CustomNavigationBar.swift
//  LMCTestUIKit
//
//  Created by Vladislav Andreev on 16.09.2024.
//

import Foundation
import UIKit

/// Кастомный NavigationBar
class CustomNavigationBar: UIView {

    let titleLabel = UILabel()
    let leftButton = UIButton()
    let rightButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        /// Цвет фона
        self.backgroundColor = Constants.Colors.color_background

        /// Тайтл
        titleLabel.text = "KinoPoisk"
        titleLabel.textColor = Constants.Colors.color_neonBlue
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        /// Левая кнопка
        leftButton.setTitle("", for: .normal)
        leftButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        leftButton.tintColor = Constants.Colors.color_neonBlue
        leftButton.translatesAutoresizingMaskIntoConstraints = false

        /// Правая кнопка
        rightButton.setTitle("", for: .normal)
        rightButton.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        rightButton.tintColor = Constants.Colors.color_neonBlue
        rightButton.translatesAutoresizingMaskIntoConstraints = false

        /// Добавляем элементы на view
        self.addSubview(titleLabel)
        self.addSubview(leftButton)
        self.addSubview(rightButton)

        /// Устанавливаем констрейнты для элементов
        NSLayoutConstraint.activate([
            leftButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            leftButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            rightButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    /// Функция для отображения кнопки назад
    func showBackButton(_ show: Bool) {
        leftButton.isHidden = !show
    }
}
