//
//  ViewController.swift
//  Argon
//
//  Created by Armando Brito on 3/11/21.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    struct ViewPost {
        let id: Int
        let user: User
        let date: Date
        let pics: [String]
    }
    
    let network = NetworkManager()
    var persistence: PersistenceManager!
    var viewPosts: [ViewPost]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        persistence = PersistenceManager()
        
        tableView.register(UINib(nibName: "\(TwoImagesCell.self)", bundle: nil), forCellReuseIdentifier: "\(TwoImagesCell.self)")
        tableView.register(UINib(nibName: "\(ThreeImagesCell.self)", bundle: nil), forCellReuseIdentifier: "\(ThreeImagesCell.self)")
        tableView.register(UINib(nibName: "\(MoreImagesCell.self)", bundle: nil), forCellReuseIdentifier: "\(MoreImagesCell.self)")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        network.getAppData { (appData) in
            guard let appData = appData else {
                return
            }
            
            appData.users.forEach({ (user) in
                self.persistence.add(user: user)
            })
            self.viewPosts = self.extractViewPosts(fromUsers: appData.users)
        }
        
        self.viewPosts = extractViewPosts(fromUsers: persistence.getUsers())
        self.tableView.reloadData()
    }
    
    func extractViewPosts(fromUsers users: [User]) -> [ViewPost] {
        var viewPosts = [ViewPost]()
        users.forEach { (user) in
            user.posts.forEach { (post) in
                let date = StringDateConverter.convert(post.date)!
                let viewPost = ViewPost(id: post.id, user: user, date: date, pics: post.pics)
                viewPosts.append(viewPost)
            }
        }
        let sortedViewPosts = viewPosts.sorted {
            $0.date > $1.date
        }
        return sortedViewPosts
    }
    
}

// MARK: - Table view data source

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewPosts = self.viewPosts else {
            return 0
        }
        
        return viewPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "\(SingleImageCell.self)", for: indexPath) as! PostCell
        guard let viewPost = self.viewPosts?[indexPath.row] else {
            return cell
        }
        
        switch viewPost.pics.count {
        case 1:
            setupSingleImageCell(cell: cell as! SingleImageCell, post: viewPost)
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "\(TwoImagesCell.self)", for: indexPath) as! TwoImagesCell
            setupTwoImagesCell(cell: cell as! TwoImagesCell, post: viewPost)
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "\(ThreeImagesCell.self)", for: indexPath) as! ThreeImagesCell
            setupThreeImagesCell(cell: cell as! ThreeImagesCell, post: viewPost)
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "\(MoreImagesCell.self)", for: indexPath) as! MoreImagesCell
            setupMoreImagesCell(cell: cell as! MoreImagesCell, post: viewPost)
        }
        
        setupUserSection(cell: cell, user: viewPost.user)
        
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
    
    func setupSingleImageCell(cell: SingleImageCell, post: ViewPost) {
        cell.dateLbl.text = StringDateFormatter.applyFormat(date: post.date)
        if let url = URL(string: post.pics.first!) {
            cell.mainImg.kf.setImage(with: url)
        } else {
            cell.mainImg.image = nil
        }
    }
    
    func setupTwoImagesCell(cell: TwoImagesCell, post: ViewPost) {
        cell.dateLbl.text = StringDateFormatter.applyFormat(date: post.date)
        guard let leftImageUrl = URL(string: post.pics[0]),
              let rightImageUrl = URL(string: post.pics[1]) else {
            return
        }
        cell.leftImage.kf.setImage(with: leftImageUrl)
        cell.rightImage.kf.setImage(with: rightImageUrl)
    }
    
    func setupThreeImagesCell(cell: ThreeImagesCell, post: ViewPost) {
        cell.dateLbl.text = StringDateFormatter.applyFormat(date: post.date)
        guard let topImageUrl = URL(string: post.pics[0]),
              let bottomLeftImg = URL(string: post.pics[1]),
              let bottomRightImg = URL(string: post.pics[2]) else {
            return
        }
        cell.topImage.kf.setImage(with: topImageUrl)
        cell.bottomLeftImg.kf.setImage(with: bottomLeftImg)
        cell.bottomRightImg.kf.setImage(with: bottomRightImg)
    }
    
    func setupMoreImagesCell(cell: MoreImagesCell, post: ViewPost) {
        cell.dateLbl.text = StringDateFormatter.applyFormat(date: post.date)
        guard let topImageUrl = URL(string: post.pics[0]) else {
            return
        }
        cell.topImage.kf.setImage(with: topImageUrl)
        cell.setBottomImages(imageURLs: Array(post.pics[1..<post.pics.count]))
    }
    
}

// MARK: - Table view delegate

extension ViewController: UITableViewDelegate {
    
}
