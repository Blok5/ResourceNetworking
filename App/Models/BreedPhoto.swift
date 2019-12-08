// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Автор: Игорь Симаков
// Описание: @warning добавить описание

import Foundation

struct BreedPhoto: Codable {
    let message: String?
    let status: String?
    
    init(message: String?, status: String?) {
        self.message = message
        self.status = status
    }
}
