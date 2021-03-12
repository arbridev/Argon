//
//  ViewController.swift
//  Argon
//
//  Created by Armando Brito on 3/11/21.
//

import UIKit

class ViewController: UIViewController {
    
    var persistence: PersistenceManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        persistence = PersistenceManager()
    }


}

