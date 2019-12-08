// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Автор: Игорь Симаков
// Описание: @warning добавить описание

import Foundation
import ResourceNetworking

class Reachability: ReachabilityProtocol {
    var isReachable: Bool
    
    init() {
        self.isReachable = true
    }
}
