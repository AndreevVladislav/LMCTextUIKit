//
//  LoginUtils.swift
//  LMCTestUIKit
//
//  Created by Vladislav Andreev on 22.09.2024.
//

import Foundation
import UIKit

class LoginUtils {
    
    /// Сохранение логина и пароля
    func saveLogin(login: String, password: String) {
        UserDefaults.standard.set(login, forKey: "currentLogin")
        savePassword(password, for: login)
    }
        
    /// Сохранение пароля в Keychain
    func savePassword(_ password: String, for login: String) {
        let passwordData = password.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: login,
            kSecValueData as String: passwordData
        ]
        SecItemAdd(query as CFDictionary, nil)
    }
        
    /// Загрузка пароля из Keychain
    func loadPassword(for login: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: login,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let passwordData = dataTypeRef as? Data {
                return String(data: passwordData, encoding: .utf8)
            }
        }
        return nil
    }
    
    /// Удаление всех зарегестрированных акканунтов
    func deleteAllAccounts() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("Все аккаунты удалены успешно.")
        } else {
            print("Ошибка удаления аккаунтов: \(status)")
        }
    }
}
