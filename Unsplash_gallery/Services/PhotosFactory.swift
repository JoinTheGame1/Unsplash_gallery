//
//  PhotosFactory.swift
//  Unsplash_gallery
//
//  Created by Никита Рыльский on 01.07.2022.
//

import Foundation

class PhotosFactory {
    
    private func generatePhotoCellModel(from response: PhotoModel) -> PhotoCellModel {
        let id = response.id ?? ""
        let aspectRatio = response.aspectRatio
        let downloadsCount = response.downloads ?? 0
        let likesCount = response.likes ?? 0
        let location = response.user?.location ?? ""
        let authorName = response.user?.name ?? ""
        
        var createdDate = ""
        let date = response.createdDate ?? ""
        if let index = date.range(of: "T")?.lowerBound {
            let temp = date[..<index]
            createdDate = String(temp)
        }
        
        guard let smallUrl = response.urls?["small"],
              let thumbUrl = response.urls?["thumb"]
        else {
            return PhotoCellModel(id: id, aspectRatio: aspectRatio, downloadsCount: downloadsCount,
                                  likesCount: likesCount, authorName: authorName,
                                  location: location, smallImage: nil, thumbImage: nil, createdDate: createdDate)
        }
        
        let smallImageUrl = URL(string: smallUrl)
        let thumbImageUrl = URL(string: thumbUrl)
        return PhotoCellModel(id: id, aspectRatio: aspectRatio, downloadsCount: downloadsCount, likesCount: likesCount,
                              authorName: authorName, location: location, smallImage: smallImageUrl,
                              thumbImage: thumbImageUrl, createdDate: createdDate)
    }
    
    func buildCellsModels(from response: [PhotoModel], completion: (([PhotoCellModel]) -> Void)) {
        let models = response.compactMap(generatePhotoCellModel)
        completion(models)
    }
}
