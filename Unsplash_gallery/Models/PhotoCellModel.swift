//
//  PhotoCellModel.swift
//  Unsplash_gallery
//
//  Created by Никита Рыльский on 01.07.2022.
//

import Foundation
import UIKit

struct PhotoCellModel: Codable {
    let id: String
    let aspectRatio: CGFloat
    let downloadsCount: Int
    var likesCount: Int
    let authorName: String
    let location: String
    let smallImage: URL?
    let thumbImage: URL?
    let createdDate: String
    var isFavourite: Bool = false
}
