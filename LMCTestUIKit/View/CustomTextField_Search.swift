//
//  CustomTextField_Search.swift
//  LMCTestUIKit
//
//  Created by Vladislav Andreev on 17.09.2024.
//

import Foundation
import UIKit

///Кастомный TextField для окна авторизации
class CustomTextField_Search: UITextField {
    
    /// Padding для текста и плейсхолдера
    private let padding = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        /// Закругленные углы
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        /// Границы
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        
        /// Цвет текста
        textColor = .white
        
        /// Фон текстового поля
        backgroundColor = Constants.Colors.color_background
        
        /// Шрифт текста
        font = UIFont.systemFont(ofSize: 16)
        
        /// Обновляем цвет плейсхолдера
        updatePlaceholder()
    }
    
    private func updatePlaceholder() {
        if let placeholderText = placeholder {
            attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
    }

    /// Переопределяем свойство placeholder, чтобы всегда обновлялся цвет
    override var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    /// Отступы для текста
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    /// Отступы для плейсхолдера
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    /// Отступы для текста при редактировании
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
