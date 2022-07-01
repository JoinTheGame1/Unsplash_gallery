//
//  PhotoInfoViewController.swift
//  Unsplash_gallery
//
//  Created by Никита Рыльский on 30.06.2022.
//

import Foundation
import UIKit

class PhotoInfoViewController: UIViewController {
    
    var photoModel: PhotoCellModel
    var isfavourite = false
    
    private let authorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.text = "FirstName SecondName"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        return label
    }()
    
    private let shadowView: UIView = {
        let shadow = UIView()
        shadow.translatesAutoresizingMaskIntoConstraints = false
        shadow.layer.cornerRadius = 8
        shadow.layer.shadowRadius = 6
        shadow.layer.shadowOpacity = 0.8
        shadow.layer.shadowOffset = .zero
        shadow.layer.shadowColor = UIColor.label.cgColor
        return shadow
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        image.image = UIImage(named: "hollow knight3")
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 8
        image.backgroundColor = .clear
        image.layer.masksToBounds = true
        return image
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "30.06.2022"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "Moscow"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    let downloadsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "37 downloads"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    let likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.isUserInteractionEnabled = true
        return likeButton
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Долгое нажатие на фотографию сохранит её на вашем устройстве"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.tintColor = .lightGray
        return label
    }()
    
    init(photoModel: PhotoCellModel) {
        self.photoModel = photoModel
        self.isfavourite = photoModel.isFavourite
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupBackButton()
        setupLikeButton()
        setupViews()
        configure()
        setupSaveGesture()
    }
    
    @objc private func back() {
        dismiss(animated: true)
    }
    
    private func setupBackButton() {
        let backImage = UIImage(systemName: "chevron.left")
        let button = UIBarButtonItem(image: backImage, style: .done, target: self,
                                     action: #selector(back))
        button.tintColor = .label
        navigationItem.setLeftBarButton(button, animated: true)
    }
    
    @objc func likeTap(_ sender: UIButton) {
        isfavourite.toggle()
        photoModel.isFavourite = isfavourite
        UIButton.transition(with: likeButton,
                            duration: 0.5,
                            options: [.transitionFlipFromLeft],
                            animations: {
                                self.photoModel.likesCount += self.isfavourite ? 1 : -1
                                self.setupLikeButton()
                            })
        isfavourite ? Favourites.shared.add(model: photoModel) : Favourites.shared.delete(model: photoModel)
    }
    
    private func setupLikeButton() {
        likeButton.setImage(isfavourite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"),
                            for: .normal)
        likeButton.imageView?.tintColor = isfavourite ? UIColor.white : UIColor.systemTeal
        likeButton.setTitle("\(photoModel.likesCount)", for: .normal)
        likeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        likeButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        likeButton.backgroundColor = isfavourite ? UIColor.systemPink : UIColor.clear
        likeButton.setTitleColor(isfavourite ? UIColor.white : UIColor.systemTeal, for: .normal)
        likeButton.clipsToBounds = true
        likeButton.layer.cornerRadius = 8
        let gesture = UITapGestureRecognizer(target: self, action: #selector(likeTap))
        likeButton.addGestureRecognizer(gesture)
    }
    
    private func setupViews() {
        view.addSubview(authorNameLabel)
        view.addSubview(shadowView)
        shadowView.addSubview(imageView)
        view.addSubview(dateLabel)
        view.addSubview(locationLabel)
        view.addSubview(downloadsLabel)
        view.addSubview(likeButton)
        view.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            authorNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            authorNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            authorNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authorNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            shadowView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shadowView.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: 16),
            shadowView.widthAnchor.constraint(equalToConstant: 300),
            shadowView.heightAnchor.constraint(equalToConstant: 300 * photoModel.aspectRatio),
            
            imageView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            dateLabel.centerXAnchor.constraint(equalTo: shadowView.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: 16),
            
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            locationLabel.centerXAnchor.constraint(equalTo: shadowView.centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            
            downloadsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            downloadsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            downloadsLabel.centerXAnchor.constraint(equalTo: shadowView.centerXAnchor),
            downloadsLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            
            likeButton.widthAnchor.constraint(equalToConstant: 100),
            likeButton.centerXAnchor.constraint(equalTo: shadowView.centerXAnchor),
            likeButton.topAnchor.constraint(equalTo: downloadsLabel.bottomAnchor, constant: 8),
            
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            infoLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    private func configure() {
        authorNameLabel.text = photoModel.authorName
        imageView.kf.setImage(with: photoModel.smallImage)
        dateLabel.text = photoModel.createdDate
        locationLabel.text = photoModel.location
        if photoModel.downloadsCount != 0 {
            downloadsLabel.text = "\(photoModel.downloadsCount) downloads"
        } else {
            downloadsLabel.isHidden = true
        }
    }
    
    @objc func showAlert(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alert = UIAlertController(title: "Ошибка!", message: error.localizedDescription,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "ОК", style: .cancel)
            alert.addAction(action)
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "", message: "Фото сохранено", preferredStyle: .alert)
            let action = UIAlertAction(title: "ОК", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    
    @objc func saveImage(gesture: UILongPressGestureRecognizer) {
        guard let image = imageView.image else { return }
        if gesture.state == .began {
            UIImageWriteToSavedPhotosAlbum(image, self,
                                           #selector(showAlert(_: didFinishSavingWithError: contextInfo:)), nil)
        }
    }
    
    private func setupSaveGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(saveImage))
        gesture.minimumPressDuration = 0.5
        imageView.addGestureRecognizer(gesture)
    }
}
