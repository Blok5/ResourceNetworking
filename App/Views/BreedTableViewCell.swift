// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Автор: Игорь Симаков
// Описание: @warning добавить описание

import UIKit

class BreedTableViewCell: UITableViewCell {
    @IBOutlet private var breedImageView: UIImageView!
    @IBOutlet private var breedLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configuration(breed: BreedView) {
        breedLabel.text = breed.description
        breedImageView.image = breed.icon
        
        if (breed.icon == nil) {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        
        
    }
}
