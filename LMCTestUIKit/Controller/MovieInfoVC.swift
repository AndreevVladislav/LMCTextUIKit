//
//  MovieInfoVC.swift
//  LMCTestUIKit
//
//  Created by Vladislav Andreev on 19.09.2024.
//

import Foundation
import UIKit

//MARK: экран информации о фильме
class MovieInfoVC: UIViewController{
    
    /// API
    private let apiUtils = APIUtils()
    
    private var movieInfo: MovieInfoModel? = nil
    
    private var frameArray = [String]()
    
    var kinopoiskIdApi = 0
    
    var imageApi = Constants.Image.img_zaglushka
    var nameApi = ""
    var genreApi = ""
    var yearApi = ""
    var countryApi = ""
    var ratingyApi = 0.0
    var framesApi = [String]()
    var link = ""
    
    ///Идентификатор ячейки CollectionView с кадрами из фильма
    let indexCellCollectionView = "CollectionViewCustomCell"
    
    /// Кнопка назад
    private let buttonBack: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.setTitle("", for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    
    /// ScrollView
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .none
        scroll.bounces = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    /// contentView
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Картинка
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = imageApi
        return image
    }()
    
    /// Градиент внизу картинки
    private let gradientLayer: CAGradientLayer = {
        let grad = CAGradientLayer()
        grad.colors = [UIColor.clear.cgColor, Constants.Colors.color_background!.cgColor]
        grad.locations = [0.3, 1.0]
        grad.opacity = 1
        return grad
    }()
    
    /// Название фильма
    private lazy var nameLable: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = nameApi
        text.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        text.textColor = UIColor.white
        return text
    }()
    
    /// Рейтинг фильма
    private lazy var ratingyLable: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = String(ratingyApi)
        text.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        text.textColor = Constants.Colors.color_neonBlue
        text.textAlignment = .right
        return text
    }()
    
    /// "Описание"
    private let descriptionTitle: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Описание"
        text.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        text.textColor = UIColor.white
        return text
    }()
    
    /// Кнопка ссылка
    private let buttonLink: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "link"), for: .normal)
        button.setTitle("", for: .normal)
        button.tintColor = Constants.Colors.color_neonBlue
        return button
    }()
    
    /// Описание фильма
    private lazy var descriptionLable: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        text.textColor = UIColor.white
        text.numberOfLines = 0
        return text
    }()
    
    /// Жанры фильма
    private lazy var genreLable: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = genreApi
        text.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        text.textColor = UIColor.lightGray
        return text
    }()

    /// Год фильма
    private lazy var yearLable: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = yearApi
        text.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        text.textColor = UIColor.lightGray
        return text
    }()
    
    /// Страна фильма
    private lazy var countryLable: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = countryApi
        text.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        text.textColor = UIColor.lightGray
        return text
    }()
    
    /// "Кадры"
    private let framesTitle: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Кадры"
        text.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        text.textColor = UIColor.white
        return text
    }()
    
    /// Карусель картинок
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    /// Текст для алерта
    private let textAlert = "Произошла какая-то ошибка. Попробуйте еще раз позже."
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.Colors.color_background
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(image)
        gradientLayer.frame = image.bounds
        image.layer.addSublayer(gradientLayer)
        contentView.addSubview(buttonBack)
        contentView.addSubview(nameLable)
        contentView.addSubview(ratingyLable)
        contentView.addSubview(descriptionTitle)
        contentView.addSubview(descriptionLable)
        contentView.addSubview(buttonLink)
        contentView.addSubview(genreLable)
        contentView.addSubview(yearLable)
        contentView.addSubview(countryLable)
        contentView.addSubview(framesTitle)
        
        //MARK: Настройка карусели картинок
        collectionView.register(CustomCollectionCellFrames.self, forCellWithReuseIdentifier: indexCellCollectionView)
        collectionView.dataSource = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .none
        contentView.addSubview(collectionView)
        
        setConstrains()
        addActions()
        
        self.apiUtils.getMovie_Info(movieId: kinopoiskIdApi, apiKey: Constants.API.apiKey) { result in
            print("Запрос вызван для фильма с ID: \(self.kinopoiskIdApi)")
            
            DispatchQueue.main.async {

                switch result {
                case .success(let movie):
                    if movie.startYear != nil && movie.endYear != nil {
                        self.yearLable.text = "\(movie.startYear ?? 0) - \(movie.endYear ?? 0)"
                    }
                    self.descriptionLable.text = movie.description
                    if let url = URL(string: movie.coverUrl ?? "") {
                        URLSession.shared.dataTask(with: url) { data, response, error in
                            if let data = data, let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self.image.image = image
                                }
                            }
                        }.resume()
                    }
                    self.link = movie.webUrl ?? ""
                case .failure(let error):
                    print("Ошибка: \(error.localizedDescription)")
                }
            }
        }
        
        self.apiUtils.getMovies_Frame(movieId: self.kinopoiskIdApi, apiKey: Constants.API.apiKey) { result in
            switch result {
            case .success(let fetchedFrames):
                let previewUrls = fetchedFrames.map { $0.previewUrl }
                self.frameArray = previewUrls
                DispatchQueue.main.async {
                    print(fetchedFrames)
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching movies: \(error)")
                APIUtils.showAlert(on: self, message: self.textAlert)
            }
        }
    }
    
    //MARK: viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        /// Установка размера градиента, равному размеру image
        gradientLayer.frame = image.bounds
    }
    
    
    //MARK: добавление действий кнопкам
    private func addActions(){
        
        buttonBack.addAction(UIAction(handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }), for: .touchUpInside)
        
        buttonLink.addAction(UIAction(handler: { [weak self] _ in
            self?.openURL("\(self?.link ?? "")")
        }), for: .touchUpInside)
        
        
    }
    
    /// Функция для открытия ссылки
    private func openURL(_ urlString: String) {
        // Проверяем, что строка является валидным URL
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            // Открываем ссылку в Safari
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            APIUtils.showAlert(on: self, message: self.textAlert)

        }
    }
    
    //MARK: констреинты
    private func setConstrains() {
        NSLayoutConstraint.activate([
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
            
            buttonBack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonBack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.heightAnchor.constraint(equalToConstant: 450),
            
            ratingyLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            ratingyLable.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: -20),
            
            nameLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLable.trailingAnchor.constraint(equalTo: ratingyLable.leadingAnchor, constant: -20),
            nameLable.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: -20),
            
            descriptionTitle.leadingAnchor.constraint(equalTo: nameLable.leadingAnchor),
            descriptionTitle.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 5),
            
            descriptionLable.leadingAnchor.constraint(equalTo: nameLable.leadingAnchor),
            descriptionLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionLable.topAnchor.constraint(equalTo: descriptionTitle.bottomAnchor, constant: 10),
            
            buttonLink.bottomAnchor.constraint(equalTo: descriptionTitle.bottomAnchor),
            buttonLink.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            genreLable.leadingAnchor.constraint(equalTo: nameLable.leadingAnchor),
            genreLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0),
            genreLable.topAnchor.constraint(equalTo: descriptionLable.bottomAnchor, constant: 10),
            
            yearLable.leadingAnchor.constraint(equalTo: nameLable.leadingAnchor),
            yearLable.topAnchor.constraint(equalTo: genreLable.bottomAnchor, constant: 10),
            
            countryLable.topAnchor.constraint(equalTo: yearLable.topAnchor),
            countryLable.leadingAnchor.constraint(equalTo: yearLable.trailingAnchor, constant: 5),
            countryLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            framesTitle.leadingAnchor.constraint(equalTo: descriptionTitle.leadingAnchor),
            framesTitle.topAnchor.constraint(equalTo: countryLable.bottomAnchor, constant: 20),
            
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: framesTitle.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
            collectionView.heightAnchor.constraint(equalToConstant: 160),
        ])
    }
}


//MARK: UICollectionViewDataSource

extension MovieInfoVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return frameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let viewModel = frameArray[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: indexCellCollectionView, for: indexPath) as! CustomCollectionCellFrames
        
        cell.backgroundColor = UIColor.clear
        if let url = URL(string: viewModel) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.image.image = image
                    }
                }
            }.resume()
        }
        
        return cell
    }
    
    
}

//MARK: UICollectionViewDelegateFlowLayout

extension MovieInfoVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let leftInset: CGFloat = 20.0
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: 0)
    }
}
    



