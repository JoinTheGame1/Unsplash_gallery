//
//  PhotoInfoViewController.swift
//  Unsplash_gallery
//
//  Created by Никита Рыльский on 30.06.2022.
//

import Foundation
import UIKit

class PhotoInfoViewController: UIViewController {
    
    let authorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.text = "FirstName SecondName"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        return label
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "hollow knight3")
        image.contentMode = .scaleAspectFill
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupBackButton()
        setupViews()
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
    
    private func setupViews() {
        view.addSubview(authorNameLabel)
        view.addSubview(imageView)
        view.addSubview(dateLabel)
        view.addSubview(locationLabel)
        view.addSubview(downloadsLabel)
        
        NSLayoutConstraint.activate([
            authorNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            authorNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            authorNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authorNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: 8),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            dateLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            locationLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            
            downloadsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            downloadsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            downloadsLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            downloadsLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
        ])
    }
    
}
