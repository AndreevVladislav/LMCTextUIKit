//
//  Constants.swift
//  LMCTestUIKit
//
//  Created by Vladislav Andreev on 16.09.2024.
//

import Foundation
import UIKit

enum Constants {
    
    enum Colors {
        static var color_background: UIColor?{
            UIColor(named: "color_16")
        }
        static var color_neonBlue = #colorLiteral(red: 0, green: 1, blue: 0.9626812339, alpha: 1)
    }
    
    enum Image {
        static var img_zaglushka = UIImage(named: "img_zaglushka")
       
    }
    
    enum API {
        static let baseURL = "https://kinopoiskapiunofficial.tech"
        static let apiKey = "de1db718-950e-449d-88a1-39a41062cee6"
    }
}
