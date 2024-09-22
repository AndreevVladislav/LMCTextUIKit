//
//  CustomCollectionCellFrames.swift
//  LMCTestUIKit
//
//  Created by Vladislav Andreev on 21.09.2024.
//

import Foundation
import UIKit

//MARK: ячейка для карусели картинок
class CustomCollectionCellFrames: UICollectionViewCell {
    
    /// Картинка
    var image: UIImageView! = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: 160).isActive = true
        image.heightAnchor.constraint(equalToConstant: 120).isActive = true
        image.layer.cornerRadius = 0
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(image)
        
        setConstrains()
        
    }
    
    //MARK: констреинты
    func setConstrains() {
        NSLayoutConstraint.activate([
            
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            image.topAnchor.constraint(equalTo: topAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

