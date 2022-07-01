//
//  FavouritesViewController.swift
//  Unsplash_gallery
//
//  Created by Никита Рыльский on 30.06.2022.
//

import Foundation
import UIKit

class FavouritesViewController: UIViewController {
    
    private var models: [PhotoCellModel] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isUserInteractionEnabled = true
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        models = Favourites.shared.favourites
        tableView.reloadData()
    }
}

extension FavouritesViewController {
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.register(FavouritePhotoCell.self, forCellReuseIdentifier: FavouritePhotoCell.identifier)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouritePhotoCell.identifier,
                                                       for: indexPath) as? FavouritePhotoCell
        else { return UITableViewCell() }
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoVC = PhotoInfoViewController(photoModel: models[indexPath.row])
        let nc = UINavigationController(rootViewController: infoVC)
        nc.modalPresentationStyle = .fullScreen
        tableView.deselectRow(at: indexPath, animated: true)
        self.present(nc, animated: true)
    }
}
