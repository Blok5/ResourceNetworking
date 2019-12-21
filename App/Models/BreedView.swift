// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Автор: Игорь Симаков
// Описание: @warning добавить описание

import Foundation
import UIKit
import ResourceNetworking

protocol BreedViewDelegate: AnyObject {
    func iconDidLoaded(breed: BreedView)
}

class BreedView {
    let uuid = UUID().uuidString
    var breed: String
    var subbreed: String?
    private var iconUrl: String?
    private(set) var icon: UIImage? {
        didSet {
            delegate?.iconDidLoaded(breed: self)
        }
    }
    weak var delegate: BreedViewDelegate?
    private var cancel: Cancellation?
    
    var description: String {
        guard let subbreed = self.subbreed else {
            return breed
        }
        return breed + "-" + subbreed
    }
    
    init(breed: String, subbreed: String?) {
        self.breed = breed
        self.subbreed = subbreed
    }
    
}

extension BreedView {
    func downloadIcon(with helper: NetworkHelper) {
        if (icon != nil) || (cancel != nil) {
            return
        }
        
        let iconUrlResource = ResourceFactor().createBreedImageUrlAPI(breed: breed, subbreedOrNil: subbreed)
        
        _ = helper.load(resource: iconUrlResource) {[weak self] result in
            switch result {
            case let .success(iconUrlResource):
                guard let breedIconResource = ResourceFactor().creareBreedIconResource(for: iconUrlResource.message) else {
                    return
                }
                self?.cancel = helper.load(resource: breedIconResource, completion: {[weak self] (result) in
                    switch result {
                    case let .success(uiImage):
                        self?.icon = uiImage
                    case .failure(_):
                        break
                    }
                    self?.cancel = nil
                })
                
            case .failure(_):
                break
            }
        }
    }
    
    func cancelDownloadIcon() {
        cancel?.cancel()
        cancel = nil
    }
}

extension BreedView: Equatable {
    static func == (lhs: BreedView, rhs: BreedView) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

extension BreedView: Comparable {
    static func < (lhs: BreedView, rhs: BreedView) -> Bool {
        lhs.description < rhs.description
    }
    
    
}
