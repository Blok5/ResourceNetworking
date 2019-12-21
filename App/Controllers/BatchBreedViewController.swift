// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Автор: Игорь Симаков
// Описание: @warning добавить описание

import UIKit
import ResourceNetworking

class BatchBreedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    enum CellIdentifiers: String {
        case BreedTableViewCell
    }
    var breedListForUI: [BreedUI] = []
    let networkHelper = NetworkHelper(reachability: Reachability()) 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
    }
    
    
}
extension BatchBreedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breedListForUI.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.BreedTableViewCell.rawValue) as! BreedTableViewCell
        cell.breedLabel.text = breedListForUI[indexPath.row].description
   
        return cell
    }
    
    
}


