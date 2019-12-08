// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Автор: Игорь Симаков
// Описание: @warning добавить описание

import UIKit
import ResourceNetworking
import Foundation

class BreedTableViewController: UIViewController {
    
    struct CellIdentifiers {
        static let BreedTableViewCell = "BreedTableViewCell"
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    let networkHelper = NetworkHelper(reachability: Reachability())
    
    //TODO: Основы параллельного программирования в Swift
    //https://apptractor.ru/info/articles/osnovyi-parallelnogo-programmirovaniya-v-swift-chast-2.html
    let semaphore = DispatchSemaphore(value: 1)
    var breedListForUI: [BreedUI] = []
    {
        didSet {
            semaphore.signal()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        willSet {
            semaphore.wait()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: CellIdentifiers.BreedTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifiers.BreedTableViewCell)
        
        //Present as a list with subbreeds and IMG urls insidew
        _ = networkHelper.load(resource: ResourceFactor().createResource()) { [weak self] result in
            switch result {
            case let .success(breeds):
                breeds.message.forEach { (key, value) in
                    //download image url for each breed without subbreed
                    if value.isEmpty {
                        _ = self?.networkHelper.load(resource: ImageResourceFactor().createResource(breed: key)) { result in
                            switch result {
                            case let .success(breedImageAPI):
                                self?.breedListForUI.append(BreedUI(breed: key, subbreed: nil, imgURL: breedImageAPI.message))
                            default:
                                break
                            }
                        }
                    } else {
                        //download image url for each subbreed
                        for subbredd in value {
                            _ = self?.networkHelper.load(resource: ImageResourceFactor().createResource(breed: key, subbreed: subbredd)) { result in
                                switch result {
                                case let .success(breedImageAPI):
                                    self?.breedListForUI.append(BreedUI(breed: key, subbreed: subbredd, imgURL: breedImageAPI.message))
                                default:
                                    break
                                }
                            }
                        }
                    }
                }
                
            default:
                break
            }
        }
        tableView.reloadData()
        
        //TODO подключить модуль с view с круглой рамкой       
    }
}

extension BreedTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breedListForUI.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.BreedTableViewCell) as! BreedTableViewCell
        cell.breedLabel.text = breedListForUI[indexPath.row].description
        
        guard let url = breedListForUI[indexPath.row].imgURL else {
            return cell
        }
        cell.breedImageView.downloadImage(from: URL(string: url)!)
        
        return cell
    }
}

//TODO: refactor with framework
//TODO: downloadTask use
extension UIImageView {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL) {
        getData(from: url) {
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
            }
        }
    }
}
