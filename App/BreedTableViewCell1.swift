// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Автор: Игорь Симаков
// Описание: @warning добавить описание

import UIKit

class BreedTableViewCell1: UITableViewCell {

    //outlet connections - A reference to an object in a storyboard from a source code file.
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var breedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
