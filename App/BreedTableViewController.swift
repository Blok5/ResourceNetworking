// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Автор: Игорь Симаков
// Описание: @warning добавить описание

import UIKit
import ResourceNetworking

class BreedTableViewController: UITableViewController {
    
    var breeds = [Breed]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBreeds()
        
        //TODO: fix tableView.rowHeight
        self.tableView.rowHeight = 100
    }

    //To display dynamic data, a table view needs two important helpers: a data source and a delegate.
    // Sections are visual groupings of cells within table views, which is especially useful in table views with a lot of data.
    
    //data source methods:
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breeds.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "BreedTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BreedTableViewCell else {
            fatalError("The dequeued cell is not an instance of BreedTableViewCell.")
        }
        
        let breed = breeds[indexPath.row]
    
        cell.breedLabel.text = breed.name
        cell.breedImageView.image = breed.photo

        return cell
    }
   
    private func loadBreeds() {
        
        //let networkHelper = NetworkHelper(reachability: )
        //TODO: replace it with load from API used framework
        let img1 = UIImage(named: "breed1")
        let img2 = UIImage(named: "breed2")
        let img3 = UIImage(named: "breed3")

        let breed1 = Breed(name: "breed1", photo: img1)
        let breed2 = Breed(name: "breed2", photo: img2)
        let breed3 = Breed(name: "breed3", photo: img3)

        breeds+=[breed1, breed2, breed3]
        
    }
}


