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
        
        tableView.register(UINib(nibName: "\(TwoImagesCell.self)", bundle: nil), forCellReuseIdentifier: "\(TwoImagesCell.self)")
        
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "\(SingleImageCell.self)", for: indexPath) as! PostCell
        guard let user = self.users?[indexPath.row] else {
            return cell
        }
        
        let firstPost = user.posts.first!
        
        if firstPost.pics.count == 1 {
            setupSingleImageCell(cell: cell as! SingleImageCell, post: firstPost)
        }
        if firstPost.pics.count == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "\(TwoImagesCell.self)", for: indexPath) as! TwoImagesCell
            setupTwoImagesCell(cell: cell as! TwoImagesCell, post: firstPost)
        }
        if firstPost.pics.count > 2 {
            setupSingleImageCell(cell: cell as! SingleImageCell, post: firstPost)
        }
        
        setupUserSection(cell: cell, user: user)
        
        return cell
    }
    
    func setupUserSection(cell: PostCell, user: User) {
        if let url = URL(string: user.profilePic) {
            cell.profileImg.kf.setImage(with: url)
        } else {
            cell.profileImg.image = nil
        }
        cell.userNameLbl.text = user.name
        cell.userEmailLbl.text = user.email
    }
    
    func setupSingleImageCell(cell: SingleImageCell, post: Post) {
        cell.dateLbl.text = StringDateFormatter.applyFormat(stringDate: post.date)
        if let url = URL(string: post.pics.first!) {
            cell.mainImg.kf.setImage(with: url)
        } else {
            cell.mainImg.image = nil
        }
    }
    
    func setupTwoImagesCell(cell: TwoImagesCell, post: Post) {
        cell.dateLbl.text = StringDateFormatter.applyFormat(stringDate: post.date)
        guard let leftImageUrl = URL(string: post.pics[0]),
              let rightImageUrl = URL(string: post.pics[1]) else {
            return
        }
        cell.leftImage.kf.setImage(with: leftImageUrl)
        cell.rightImage.kf.setImage(with: rightImageUrl)
    }
    
}

// MARK: - Table view delegate

extension ViewController: UITableViewDelegate {
    
}
