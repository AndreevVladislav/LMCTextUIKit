//
//  YearPickerButton.swift
//  LMCTestUIKit
//
//  Created by Vladislav Andreev on 19.09.2024.
//

import Foundation
import UIKit

///Кнопка с выбором года
class YearPickerButton: UIButton, UIPickerViewDelegate, UIPickerViewDataSource {

    private let years = Array((1900...2024).reversed()) // Массив годов
    private var selectedYear: Int?

    // Конструктор для создания кнопки
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    // Настройка кнопки
    private func setupButton() {
        self.setTitle("Выберите год", for: .normal)
        self.setTitleColor(UIColor.lightGray, for: .normal)
        self.backgroundColor = .clear
        self.layer.cornerRadius = 5
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addTarget(self, action: #selector(showYearPicker), for: .touchUpInside)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
    }

    // Показать UIPickerView в качестве модального представления
    @objc private func showYearPicker() {
        guard let parentViewController = self.parentViewController else { return }

        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)

        // Создайте UIPickerView
        let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: alertController.view.bounds.width - 20, height: 216))
        picker.delegate = self
        picker.dataSource = self
        picker.selectRow(0, inComponent: 0, animated: false)

        alertController.view.addSubview(picker)

        // Кнопка "Подтвердить"
        let confirmAction = UIAlertAction(title: "Подтвердить", style: .default) { _ in
            if let year = self.selectedYear {
                self.setTitle("\(year)", for: .normal)
                if let parentVC = self.parentViewController as? HomeVC {
                    parentVC.selectedYear = year
                }
            }
        }

        // Кнопка "Отмена"
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        // Кнопка "Сбросить"
        let resetAction = UIAlertAction(title: "Сбросить", style: .default) { _ in
            self.setTitle("Выберите год", for: .normal)
            if let parentVC = self.parentViewController as? HomeVC {
                parentVC.selectedYear = 0
            }
        }

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        alertController.addAction(resetAction)

        // Показать UIPickerView
        parentViewController.present(alertController, animated: true, completion: nil)
    }

    // MARK: - UIPickerView DataSource & Delegate

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(years[row])"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedYear = years[row]
    }
}

// Расширение для поиска родительского ViewController
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
