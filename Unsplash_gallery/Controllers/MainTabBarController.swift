//
//  MainTabBarController.swift
//  Unsplash_gallery
//
//  Created by Никита Рыльский on 30.06.2022.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        let randomPhotosVC = RandomPhotosViewController()
        
        let randomPhotosImage = UIImage(systemName: "photo.fill.on.rectangle.fill") ?? UIImage()
        viewControllers = [
            generateNavigationController(rootViewController: randomPhotosVC, title: "dwqw", image: randomPhotosImage)
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        navigationVC.setNavigationBarHidden(true, animated: true)
        return navigationVC
    }
}
