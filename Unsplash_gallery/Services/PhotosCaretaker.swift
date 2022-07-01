//
//  PhotosCaretaker.swift
//  Unsplash_gallery
//
//  Created by Никита Рыльский on 01.07.2022.
//

import Foundation

class PhotosCaretaker {
    
    private let emptyModels: [PhotoCellModel] = []
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let key = "PhotoCellModels"
    
    func save(models: [PhotoCellModel]) {
        do {
            let data = try self.encoder.encode(models)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            debugPrint(String(describing: error))
        }
    }
    
    func load() -> [PhotoCellModel] {
        guard let data = UserDefaults.standard.data(forKey: key)
        else { return emptyModels }
        
        do {
            let models = try self.decoder.decode([PhotoCellModel].self, from: data)
            return models
        } catch {
            debugPrint(String(describing: error))
            return emptyModels
        }
    }
    
    func delete(model: PhotoCellModel) {
        do {
            let models = load()
            let newModels = models.filter { $0.id != model.id }
            let data = try self.encoder.encode(newModels)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            debugPrint(String(describing: error))
        }
    }
}
