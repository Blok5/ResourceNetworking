// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Автор: Игорь Симаков
// Описание: @warning добавить описание

import Foundation
import ResourceNetworking
struct BreedImageAPI: Codable {
    var message: String
    var status: String
}

//https://dog.ceo/api/breed/hound/images/random Fetch!
//https://dog.ceo/api/breed/bulldog-french/images/random
//    "message": "https://images.dog.ceo/breeds/hound-english/n02089973_1132.jpg",
//get a sub breed random image
//https://dog.ceo/api/breed/hound/afghan/images/random


class ImageResourceFactor {
    func createResource(breed: String, subbreed: String = "") -> Resource<BreedImageAPI> {
        let path = subbreed.isEmpty ? breed : breed + "/" + subbreed
        return Resource(url: URL(string: "https://dog.ceo/api/breed/" + path + "/images/random")!, headers: nil)
    }
}
