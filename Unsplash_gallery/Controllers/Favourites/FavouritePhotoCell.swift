//
//  FavouritePhotoCell.swift
//  Unsplash_gallery
//
//  Created by Никита Рыльский on 30.06.2022.
//

import Foundation
import UIKit
import Kingfisher

class FavouritePhotoCell: UITableViewCell {
    
    static let identifier = "FavouritePhotoCell"
    
    var photoModel: PhotoCellModel?
    
    let shadowView: UIView = {
        let shadow = UIView()
        shadow.translatesAutoresizingMaskIntoConstraints = false
        shadow.layer.cornerRadius = 8
        shadow.layer.shadowRadius = 4
        shadow.layer.shadowOpacity = 0.8
        shadow.layer.shadowOffset = .zero
        shadow.layer.shadowColor = UIColor.label.cgColor
        return shadow
    }()
    
    let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "hollow knight3")
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.label.cgColor
        image.layer.cornerRadius = 8
        image.layer.masksToBounds = true
        return image
    }()
    
    let authorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.text = "FirstName SecondName"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
        authorNameLabel.text = ""
    }
    
    private func setupCell() {
        contentView.addSubview(shadowView)
        shadowView.addSubview(image)
        contentView.addSubview(authorNameLabel)
        
        NSLayoutConstraint.activate([
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            shadowView.widthAnchor.constraint(equalToConstant: 120 * (1 / (photoModel?.aspectRatio ?? 1))),
            shadowView.heightAnchor.constraint(equalToConstant: 120),
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            image.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            image.topAnchor.constraint(equalTo: shadowView.topAnchor),
            image.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            
            authorNameLabel.leadingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: 16),
            authorNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            authorNameLabel.centerYAnchor.constraint(equalTo: shadowView.centerYAnchor)
        ])
    }
    
    func configure(with model: PhotoCellModel) {
        self.photoModel = model
        image.kf.setImage(with: model.smallImage)
        authorNameLabel.text = model.authorName
    }
}
