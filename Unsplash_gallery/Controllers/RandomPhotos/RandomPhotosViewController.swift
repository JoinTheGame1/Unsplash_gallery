//
//  RandomPhotosViewController.swift
//  Unsplash_gallery
//
//  Created by Никита Рыльский on 30.06.2022.
//

import Foundation
import UIKit

class RandomPhotosViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    private var networkService = NetworkService()
    private var isLoading = false
    private var query: String = ""
    private let caretaker = PhotosCaretaker()
    private let factory = PhotosFactory()
    private var models: [PhotoCellModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addNotifications()
        setupCollectionView()
        getRandomPhotos(completion: {})
    }
    
    deinit {
        removeNotifications()
    }
}

extension RandomPhotosViewController {
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        guard let collectionView = collectionView else { return }
        
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isUserInteractionEnabled = true
        collectionView.register(RandomPhotoCell.self, forCellWithReuseIdentifier: RandomPhotoCell.identifier)
        
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        searchBar.delegate = self
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWasShown(notification: Notification) {
        addTapOnView()
    }
    
    @objc private func keyboardWillBeHidden(notification: Notification) {
        view.gestureRecognizers?.forEach(view.removeGestureRecognizer)
    }
    
    private func addTapOnView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    private func getRandomPhotos(completion: @escaping () -> Void) {
        networkService.getRandomPhotos { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .failure:
                    print("GET RANDOM PHOTOS ERROR")
                case .success(let models):
                    self.factory.buildCellsModels(from: models) { models in
                        self.models.append(contentsOf: models)
                    }
            }
        }
    }
    
    private func getSearchPhotos() {
        networkService.getSearchPhotos(query: self.query) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .failure:
                    print("GET SEARCH PHOTOS ERROR")
                case .success(let models):
                    self.factory.buildCellsModels(from: models) { models in
                        self.models = models
                    }
            }
        }
    }
    
}

extension RandomPhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RandomPhotoCell.identifier,
                                                            for: indexPath) as? RandomPhotoCell
        else { return UICollectionViewCell() }
        let url = models[indexPath.item].smallImage
        cell.configure(with: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let infoVC = PhotoInfoViewController(photoModel: models[indexPath.item])
        let nc = UINavigationController(rootViewController: infoVC)
        nc.modalPresentationStyle = .fullScreen
        self.present(nc, animated: true)
    }
}

extension RandomPhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let photo = models[indexPath.item]
        let itemHeight = width * photo.aspectRatio
        return CGSize(width: width, height: itemHeight)
    }
}

extension RandomPhotosViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        query = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getSearchPhotos()
    }
}

extension RandomPhotosViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let maxIndex = indexPaths.last?.item else { return }
        if maxIndex > models.count - 7,
           !isLoading {
            isLoading = true
            getRandomPhotos {
                self.isLoading = false
            }
        }
    }
}
