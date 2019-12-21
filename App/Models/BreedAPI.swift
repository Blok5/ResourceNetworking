// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Автор: Игорь Симаков
// Описание: @warning добавить описание

import Foundation
import ResourceNetworking
import UIKit

struct BreedsAPI: Codable {
    let message: [String: [String]]
    let status: String
}

struct BreedImageUrlAPI: Codable {
    let message: String
    let status: String
}

struct ResourceFactor {
    func createBreedsResource() -> Resource<BreedsAPI> {
        return Resource(url: URL(string: "https://dog.ceo/api/breeds/list/all")!, headers: nil)
    }
    
    func createBreedImageUrlAPI(breed: String, subbreedOrNil: String?) -> Resource<BreedImageUrlAPI>{
        let path = (subbreedOrNil == nil) ? breed : breed + "/" + subbreedOrNil!
        let url = URL(string: "https://dog.ceo/api/breed/" + path + "/images/random")!
        return Resource<BreedImageUrlAPI>(url: url, headers: nil)
    }
    
    func creareBreedIconResource(for urlString: String) -> Resource<UIImage>? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        let parse: (Data) throws -> UIImage = {data in
            guard let image = UIImage(data: data) else {
                throw NSError(domain: "can't create UIImage from data \(data)", code: 129, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("msString", comment: "myComment")])
            }
            return image
        }
        return Resource(url: url, method: .get, parse: parse)
    }

}


