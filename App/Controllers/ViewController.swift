// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Автор: Игорь Симаков
// Описание: @warning добавить описание

import UIKit

class ViewController: UIViewController {
    
    //TODO подключить модуль с view с круглой рамкой
    @IBOutlet weak var button: UIButton!
    
    override func loadView() {
        super.loadView()
        
        print("loadView")
        
        //button.setTitle("IGOR", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")

    }

    @IBAction func buttonAction(_ sender: Any) {
        print("Igor button inter")
    }
    
}

