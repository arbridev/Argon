//
//  ViewController.swift
//  Argon
//
//  Created by Armando Brito on 3/11/21.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    var persistence: PersistenceManager!

    @IBOutlet weak var centerImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        persistence = PersistenceManager()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let network = NetworkManager()
        network.getAppData()
        
        if let url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Wikipedia-logo-v2-en.svg/1200px-Wikipedia-logo-v2-en.svg.png") {
            centerImg.kf.setImage(with: url)
        }
    }


}

