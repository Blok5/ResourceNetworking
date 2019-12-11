// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Автор: Игорь Симаков
// Описание: @warning добавить описание

import UIKit
import ResourceNetworking
import Foundation

class BreedTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let networkHelper = NetworkHelper(reachability: Reachability())
    
    enum CellIdentifiers: String {
        case BreedTableViewCell
    }
    
    let queue = OperationQueue()
      
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
        self.queue.maxConcurrentOperationCount = 1
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: CellIdentifiers.BreedTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifiers.BreedTableViewCell.rawValue)
        
        //Present as a list with subbreeds and IMG urls insidew
        _ = networkHelper.load(resource: ResourceFactor().createResource()) { [weak self] result in
            switch result {
            case let .success(breeds):
                breeds.message.forEach { (key, value) in
                    //download image url for each breed without subbreed
                    if value.isEmpty {
                        _ = self?.networkHelper.load(resource: ImageResourceFactor().createResource(breed: key)) { [weak self] result in
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
                            _ = self?.networkHelper.load(resource: ImageResourceFactor().createResource(breed: key, subbreed: subbredd)) { [weak self] result in
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
    }
    
}

extension BreedTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breedListForUI.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.BreedTableViewCell.rawValue) as! BreedTableViewCell
        cell.breedLabel.text = breedListForUI[indexPath.row].description
        
        guard let url = breedListForUI[indexPath.row].imgURL else {
            return cell
        }
        
        let operation = DownloadOperation(session: URLSession.shared, downloadTaskURL: URL(string: url)! ) { (urlOrNil, responseOrNil, errorOrNil) in
            print("finished downloading")
            guard let url = urlOrNil, errorOrNil == nil else {
                return
            }
            let data = try? Data(contentsOf: url.absoluteURL)
            
            DispatchQueue.main.async() {
                cell.breedImageView.image = UIImage(data: data!)
            }
        }
        
        queue.addOperation(operation)
        
        return cell
    }
    
}

