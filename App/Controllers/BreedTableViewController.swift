// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Автор: Игорь Симаков
// Описание: @warning добавить описание

import UIKit
import ResourceNetworking
import Foundation
import Network

class BreedTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let networkHelper = NetworkHelper(reachability: Reachability())
    
    enum CellIdentifiers: String {
        case BreedTableViewCell
    }
    
    var breedListForUI: [BreedView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        registerTableViewCells()
        
        _ = networkHelper.load(resource: ResourceFactor().createBreedsResource()) { [weak self] result in
            switch result {
            case let .success(breeds):
                var breedViews: [BreedView] = []
                
                let res: [[BreedView]] = breeds.message.compactMap { [weak self] key, value in
                    let values: [String?] = value.count > 0 ? value: [nil]
                    return values.map { (subbreed) in
                        let dog = BreedView(breed: key, subbreed: subbreed)
                        dog.delegate = self
                        return dog
                    }
                }
                
                breedViews = res.reduce([], +)
                
//                breeds.message.forEach { (key: String, value: [String]) in
//                    switch value.count {
//                    case 0:
//                        let breedView = BreedView(breed: key, subbreed: nil)
//                        breedView.delegate = self
//                        breedViews.append(breedView)
//                    default:
//                        value.forEach { (subbreed) in
//                            let breedView = BreedView(breed: key, subbreed: subbreed)
//                            breedView.delegate = self
//                            breedViews.append(breedView)
//                        }
//                    }
//                }
                
                self?.breedListForUI = breedViews
                self?.breedListForUI.sort(by: <)
                
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
                
            case let .failure(error):
                print("eeerrrr", error)
                break
            
            }
            
        }
        
    }
    
    func registerTableViewCells() {
        tableView.register(UINib(nibName: CellIdentifiers.BreedTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier:
            CellIdentifiers.BreedTableViewCell.rawValue)
    }
    
}

extension BreedTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breedListForUI.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.BreedTableViewCell.rawValue) as! BreedTableViewCell
        cell.configuration(breed: breedListForUI[indexPath.row])
        return cell
    }
}

extension BreedTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        breedListForUI[indexPath.row].downloadIcon(with: networkHelper)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        breedListForUI[indexPath.row].cancelDownloadIcon()
    }
}


extension BreedTableViewController: BreedViewDelegate {
    func iconDidLoaded(breed: BreedView) {
        guard let row = breedListForUI.firstIndex(of: breed) else {
            return
        }
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
        }
    }
}



