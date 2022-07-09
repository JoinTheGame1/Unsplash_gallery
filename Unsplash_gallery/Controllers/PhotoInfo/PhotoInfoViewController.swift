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
    
    lazy var scrollView: UIScrollView = makeScrollView()
    lazy var authorNameLabel: UILabel = makeAuthorNameLabel()
    lazy var shadowView: UIView = makeShadowView()
    lazy var imageView: UIImageView = makeImageView()
    lazy var dateLabel: UILabel = makeDateLabel()
    lazy var locationLabel: UILabel = makeLocationLabel()
    lazy var downloadsLabel: UILabel = makeDownloadsLabel()
    lazy var likeButton: UIButton = makeLikeButton()
    lazy var infoLabel: UILabel = makeInfoLabel()
    
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
    
    private func setupBackButton() {
        let backImage = UIImage(systemName: "chevron.left")
        let button = UIBarButtonItem(image: backImage, style: .done, target: self,
                                     action: #selector(back))
        button.tintColor = .label
        navigationItem.setLeftBarButton(button, animated: true)
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
        view.addSubview(scrollView)
        scrollView.addSubview(authorNameLabel)
        scrollView.addSubview(shadowView)
        shadowView.addSubview(imageView)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(locationLabel)
        scrollView.addSubview(downloadsLabel)
        scrollView.addSubview(likeButton)
        scrollView.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            authorNameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 4),
            authorNameLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -4),
            authorNameLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            authorNameLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            
            shadowView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            shadowView.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: 16),
            shadowView.widthAnchor.constraint(equalToConstant: 300),
            shadowView.heightAnchor.constraint(equalToConstant: 300 * photoModel.aspectRatio),
            
            imageView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: authorNameLabel.leadingAnchor, constant: 4),
            dateLabel.trailingAnchor.constraint(equalTo: authorNameLabel.trailingAnchor, constant: -4),
            dateLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: 16),
            
            locationLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: 4),
            locationLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: -4),
            locationLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            
            downloadsLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor, constant: 4),
            downloadsLabel.trailingAnchor.constraint(equalTo: locationLabel.trailingAnchor, constant: -4),
            downloadsLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            downloadsLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            
            likeButton.widthAnchor.constraint(equalToConstant: 100),
            likeButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            likeButton.topAnchor.constraint(equalTo: downloadsLabel.bottomAnchor, constant: 8),
            
            infoLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 4),
            infoLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -4),
            infoLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 8),
            infoLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
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
