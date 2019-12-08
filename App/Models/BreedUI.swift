// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Автор: Игорь Симаков
// Описание: @warning добавить описание

import Foundation
import UIKit

struct BreedUI {
    var breed: String = ""
    var subbreed: String? = nil
    var imgURL: String? = nil
    
    var description: String {
        guard let subbreed = self.subbreed else {
            return breed
        }
        
        return breed + "-" + subbreed
    }
    
    init(breed: String, subbreed: String?, imgURL: String?) {
       // print("has been inited with \(imgURL)")
        self.breed = breed
        self.subbreed = subbreed
        self.imgURL = imgURL
    }

}
