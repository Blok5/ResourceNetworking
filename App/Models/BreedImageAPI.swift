// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Автор: Игорь Симаков
// Описание: @warning добавить описание

import Foundation
import ResourceNetworking
struct BreedImageAPI: Codable {
    var message: String
    var status: String
}

class ImageResourceFactor {
    func createResource(breed: String, subbreed: String = "") -> Resource<BreedImageAPI> {
        let path = subbreed.isEmpty ? breed : breed + "/" + subbreed
        return Resource(url: URL(string: "https://dog.ceo/api/breed/" + path + "/images/random")!, headers: nil)
    }
}
