// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Автор: Игорь Симаков
// Описание: @warning добавить описание

import Foundation
import ResourceNetworking

struct BreedArrayAPI: Codable {
    let message: [String: [String]]
    let status: String
    
    init() {
        message = ["": []]
        status = ""
    }
}

class ResourceFactor {
    func createResource() -> Resource<BreedArrayAPI> {
        return Resource(url: URL(string: "https://dog.ceo/api/breeds/list/all")!, headers: nil)
    }
}
