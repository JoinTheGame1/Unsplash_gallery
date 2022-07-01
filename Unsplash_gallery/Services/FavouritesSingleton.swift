//
//  FavouritesSingleton.swift
//  Unsplash_gallery
//
//  Created by Никитка on 01.07.2022.
//

import Foundation

class Favourites {
    
    static let shared = Favourites()
    private let caretaker = PhotosCaretaker()
    var favourites: [PhotoCellModel] {
        didSet {
            caretaker.save(models: favourites)
        }
    }
    
    private init() {
        favourites = caretaker.load()
    }
    
    func add(model: PhotoCellModel) {
        favourites.append(model)
    }
    
    func delete(model: PhotoCellModel) {
        caretaker.delete(model: model)
        favourites = caretaker.load()
    }
}
