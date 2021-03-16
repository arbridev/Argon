//
//  ViewController.swift
//  Argon
//
//  Created by Armando Brito on 3/11/21.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    let network = NetworkManager()
    var persistence: PersistenceManager!
    var users: [User]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        persistence = PersistenceManager()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        network.getAppData { (appData) in
            guard let appData = appData else {
                return
            }

            self.users = appData.users
            self.users?.forEach({ (user) in
                self.persistence.add(user: user)
            })
        }
        
        self.users = persistence.getUsers()
        self.tableView.reloadData()
    }
    
}

// MARK: - Table view data source

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let users = self.users else {
            return 0
        }
        
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(SingleImageCell.self)", for: indexPath) as! SingleImageCell
        guard let user = self.users?[indexPath.row] else {
            return cell
        }
        if let url = URL(string: user.profilePic) {
            cell.profileImg.kf.setImage(with: url)
        } else {
            cell.profileImg.image = nil
        }
        cell.userNameLbl.text = user.name
        cell.userEmailLbl.text = user.email
        
        let firstPost = user.posts.first!
        cell.dateLbl.text = StringDateFormatter.applyFormat(stringDate: firstPost.date)
        if let url = URL(string: firstPost.pics.first!) {
            cell.mainImg.kf.setImage(with: url)
        } else {
            cell.mainImg.image = nil
        }
        
        return cell
    }
    
}

// MARK: - Table view delegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 440.0
    }
    
}
