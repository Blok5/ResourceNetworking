// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Автор: Игорь Симаков
// Описание: @warning добавить описание

import Foundation

struct BreedArray {
    let message: [String: [String]]
    let status: String
    
    init(message: [String: [String]], status: String) {
        self.message = message
        self.status = status
    }
}
