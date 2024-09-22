//
//  HomeVC.swift
//  LMCTestUIKit
//
//  Created by Vladislav Andreev on 16.09.2024.
//

import Foundation
import UIKit

/// Домашний экран
class HomeVC: UIViewController, UITextFieldDelegate {
    
    /// API
    private let apiUtils = APIUtils()
    
    ///выбранный год фильмов
    var selectedYear = 0
    
    /// Массив фильмов
    var movies = [MovieModel]()
    
    ///Идентификатор ячейки таблицы с фильмами
    let indexCellTableView = "MovieIndex"
    
    /// Массив годов для выпадающего списка
    private let years = Array(1900...2024).reversed()
    
    /// NavigationBar
    private let customNavigationBar: CustomNavigationBar = {
        let navBar = CustomNavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()
    
    /// Кнопка  справа (поисковая лупа)
    private let searchIconButton: UIButton = {
        let button = UIButton()
        button.tintColor = Constants.Colors.color_neonBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("", for: .normal)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)        
        return button
    }()
    
    /// Кнопка  слева  (сортировка)
    private let sortingIconButton: UIButton = {
        let button = UIButton()
        button.tintColor = Constants.Colors.color_neonBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("", for: .normal)
        button.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        return button
    }()
    
    /// Поле ввода поиска
    private let searchTextField = UITextField()
    
    /// Кнопка выбора года
    private let yearPickerButton = YearPickerButton()
    
    /// Таблица с фильмами
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero , style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    /// Текст для алерта
    private let textAlert = "Произошла какая-то ошибка. Мы не смогли найти кинчик, который вы хотите. Проверьте подключение к интернету и повторите попытку."
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.Colors.color_background
        
        setupNavigationView()
        setupSearchTextField()
        setupTableView()
        setupRefreshControl()
        
        view.addSubview(searchIconButton)
        view.addSubview(sortingIconButton)
        view.addSubview(yearPickerButton)
        
        setConstrains()
        addActions()
        
        
        
        self.apiUtils.getMovies_Popular(apiKey: Constants.API.apiKey) { result in
            switch result {
            case .success(let fetchedMovies):
                self.movies = fetchedMovies
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching movies: \(error)")
                APIUtils.showAlert(on: self, message: self.textAlert)
            }
        }
        
    }
    
    // MARK: - Настройка NavigationView
    private func setupNavigationView() {
        view.addSubview(customNavigationBar)
        customNavigationBar.rightButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        ///флаг отображения левой кнопки
        customNavigationBar.showBackButton(false)
    }
    /// Действие правой кнопки
    @objc func logoutButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Настройка текстового поля поиска
    private func setupSearchTextField() {
        
        view.addSubview(searchTextField)
        searchTextField.delegate = self
        searchTextField.backgroundColor = UIColor.clear
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.gray.cgColor
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Что посмотрим сегодня?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        searchTextField.layer.cornerRadius = 5
        searchTextField.textColor = UIColor.white
        searchTextField.font = UIFont.systemFont(ofSize: 16)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        let spacerViewLeft = UIView(frame:CGRect(x: 0, y: 0, width: 12, height: 12))
        searchTextField.leftViewMode = .always
        searchTextField.leftView = spacerViewLeft
        let spacerViewRight = UIView(frame:CGRect(x: 0, y: 0, width: 45, height: 12))
        searchTextField.rightViewMode = .always
        searchTextField.rightView = spacerViewRight
        
    }
    
    // MARK: - Настройка таблицы
    private func setupTableView() {
        tableView.register(CustomTableViewCellMovie.self, forCellReuseIdentifier: indexCellTableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 160
        tableView.separatorStyle = .none
        tableView.backgroundColor = .none
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
    }
    
    //MARK: обновлялка таблицы
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable(_:)), for: .valueChanged)
        refreshControl.tintColor = Constants.Colors.color_neonBlue
        tableView.refreshControl = refreshControl
    }
    
    @objc func refreshTable(_ sender: AnyObject) {
        var yearFrom = 0
        var yearTo = 0
        if self.selectedYear == 0 {
            yearFrom = 1000
            yearTo = 3000
        } else {
            yearFrom = self.selectedYear
            yearTo = self.selectedYear
        }
        self.apiUtils.getMovies_WithFilter(yearFrom: yearFrom,
                                            yearTo: yearTo,
                                            keyword: self.searchTextField.text ?? "",
                                            page: 1,
                                            apiKey: Constants.API.apiKey) { result in
            switch result {
            case .success(let fetchedMovies):
                self.movies = fetchedMovies
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.refreshControl?.endRefreshing()
                }
            case .failure(let error):
                print("Error fetching movies: \(error)")
                APIUtils.showAlert(on: self, message: self.textAlert)
            }
        }
        
    }
    
    // MARK: - Добавление действий кнопкам
    private func addActions(){
        searchIconButton.addAction(UIAction(handler: { [weak self] _ in
            var yearFrom = 0
            var yearTo = 0
            if self?.selectedYear == 0 {
                yearFrom = 1000
                yearTo = 3000
            } else {
                yearFrom = self?.selectedYear ?? 0
                yearTo = self?.selectedYear ?? 0
            }
            self?.apiUtils.getMovies_WithFilter(yearFrom: yearFrom,
                                                yearTo: yearTo,
                                                keyword: self?.searchTextField.text ?? "",
                                                page: 1,
                                                apiKey: Constants.API.apiKey) { result in
                switch result {
                case .success(let fetchedMovies):
                    self?.movies = fetchedMovies
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print("Error fetching movies: \(error)")
                    APIUtils.showAlert(on: self ?? HomeVC(), message: self?.textAlert ?? "")
                }
            }
        }), for: .touchUpInside)
        
        sortingIconButton.addAction(UIAction(handler: { [weak self] _ in
            self?.movies.reverse()
            self?.tableView.reloadData()
        }), for: .touchUpInside)
    }
    
    //MARK: констреинты
    private func setConstrains() {
        NSLayoutConstraint.activate([
            
            customNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: 60),
            
            sortingIconButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            sortingIconButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sortingIconButton.widthAnchor.constraint(equalToConstant: 24),
            
            searchTextField.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: sortingIconButton.trailingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            
            searchIconButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            searchIconButton.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: -20),
            
            yearPickerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            yearPickerButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            yearPickerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            yearPickerButton.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: yearPickerButton.bottomAnchor, constant: 20),
            
        ])
    }
}

//MARK: UITableViewDataSource

extension HomeVC: UITableViewDataSource {
    //количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    //вид ячеек
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indexCellTableView, for: indexPath) as! CustomTableViewCellMovie
        let viewModel = movies[indexPath.row]
        
        cell.backgroundColor = UIColor.clear
        if let url = URL(string: viewModel.posterUrlPreview) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.image.image = image
                    }
                }
            }.resume()
        }
        if viewModel.nameOriginal != nil {
            cell.nameLable.text = viewModel.nameOriginal
        } else if viewModel.nameEn != nil {
            cell.nameLable.text = viewModel.nameEn
        } else {
            cell.nameLable.text = viewModel.nameRu
        }
        let genreNames = viewModel.genres.map { $0.genre }
        let joinedGenre = genreNames.joined(separator: ", ")
        cell.genreLable.text = joinedGenre
        cell.yearCountryLable.text = "\(viewModel.year), \(viewModel.countries[0].country)"
        cell.ratingyLable.text = String(viewModel.ratingKinopoisk ?? viewModel.ratingImdb ?? 0)
        cell.selectionStyle = .none
        
        return cell
    }
    
}

//MARK: UITableViewDelegate

extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let vc = MovieInfoVC()
        let viewModel = movies[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        vc.kinopoiskIdApi = viewModel.kinopoiskId
        if viewModel.nameOriginal != nil {
            vc.nameApi = viewModel.nameOriginal ?? "error"
        } else if viewModel.nameEn != nil {
            vc.nameApi = viewModel.nameEn ?? "error"
        } else {
            vc.nameApi = viewModel.nameRu ?? "error"
        }
        vc.ratingyApi = viewModel.ratingKinopoisk ?? viewModel.ratingImdb ?? 0
        vc.yearApi = "\(viewModel.year),"
        let countryNames = viewModel.countries.map { $0.country }
        let joinedCountry = countryNames.joined(separator: ", ")
        vc.countryApi = joinedCountry
        let genreNames = viewModel.genres.map { $0.genre }
        let joinedGenre = genreNames.joined(separator: ", ")
        vc.genreApi = joinedGenre
        
        present(vc, animated: true, completion: nil)
    }
}

