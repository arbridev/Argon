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
    var popUpImage: UIView?
    var popUpImageSwipeGesture: UISwipeGestureRecognizer!
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        persistence = PersistenceManager()
        
        tableView.register(UINib(nibName: "\(TwoImagesCell.self)", bundle: nil), forCellReuseIdentifier: "\(TwoImagesCell.self)")
        tableView.register(UINib(nibName: "\(ThreeImagesCell.self)", bundle: nil), forCellReuseIdentifier: "\(ThreeImagesCell.self)")
        tableView.register(UINib(nibName: "\(MoreImagesCell.self)", bundle: nil), forCellReuseIdentifier: "\(MoreImagesCell.self)")
        
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData(completion: nil)
        
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
        return viewPosts
    }
    
    func fetchData(completion: ((_ success: Bool) -> ())?) {
        network.getAppData { (appData) in
            guard let appData = appData else {
                completion?(false)
                return
            }
            
            appData.users.forEach({ (user) in
                self.persistence.add(user: user)
            })
            self.viewPosts = self.extractViewPosts(fromUsers: appData.users)
            self.tableView.reloadData()
            completion?(true)
        }
    }
    
    func popImage(image: UIImage) {
        popUpImage = UIView(frame: view.bounds)
        view.addSubview(popUpImage!)
        let blurEffect = UIBlurEffect(style: .dark)
        let backdrop = UIVisualEffectView(effect: blurEffect)
        backdrop.frame = popUpImage!.bounds
        popUpImage?.addSubview(backdrop)
        let imageView = UIImageView(frame: view.bounds)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        popUpImage?.addSubview(imageView)
        popUpImageSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissPoppedImage(_:)))
        popUpImageSwipeGesture.direction = .down
        backdrop.addGestureRecognizer(popUpImageSwipeGesture)
        
        self.popUpImage?.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.popUpImage?.alpha = 1.0
        }, completion: nil)
    }
    
    @objc func dismissPoppedImage(_ sender: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.4) {
            self.popUpImage?.alpha = 0
        } completion: { (completed) in
            self.popUpImage?.removeFromSuperview()
            self.popUpImage = nil
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        fetchData { (success) in
            self.refreshControl.endRefreshing()
        }
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
        
        if isFirstUserPost(row: indexPath.row) {
            cell.omitUserSection(false)
            setupUserSection(cell: cell, user: viewPost.user)
        } else {
            cell.omitUserSection(true)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    private func setupUserSection(cell: PostCell, user: User) {
        if let url = URL(string: user.profilePic) {
            cell.profileImg.kf.setImage(with: url)
        } else {
            cell.profileImg.image = nil
        }
        cell.userNameLbl.text = user.name
        cell.userEmailLbl.text = user.email
    }
    
    private func setupSingleImageCell(cell: SingleImageCell, post: ViewPost) {
        cell.dateLbl.text = StringDateFormatter.applyFormat(date: post.date)
        if let url = URL(string: post.pics.first!) {
            cell.mainImg.kf.setImage(with: url)
        } else {
            cell.mainImg.image = nil
        }
        cell.delegate = self
    }
    
    private func setupTwoImagesCell(cell: TwoImagesCell, post: ViewPost) {
        cell.dateLbl.text = StringDateFormatter.applyFormat(date: post.date)
        guard let leftImageUrl = URL(string: post.pics[0]),
              let rightImageUrl = URL(string: post.pics[1]) else {
            return
        }
        cell.leftImage.kf.setImage(with: leftImageUrl)
        cell.rightImage.kf.setImage(with: rightImageUrl)
        cell.delegate = self
    }
    
    private func setupThreeImagesCell(cell: ThreeImagesCell, post: ViewPost) {
        cell.dateLbl.text = StringDateFormatter.applyFormat(date: post.date)
        guard let topImageUrl = URL(string: post.pics[0]),
              let bottomLeftImg = URL(string: post.pics[1]),
              let bottomRightImg = URL(string: post.pics[2]) else {
            return
        }
        cell.topImage.kf.setImage(with: topImageUrl)
        cell.bottomLeftImg.kf.setImage(with: bottomLeftImg)
        cell.bottomRightImg.kf.setImage(with: bottomRightImg)
        cell.delegate = self
    }
    
    private func setupMoreImagesCell(cell: MoreImagesCell, post: ViewPost) {
        cell.dateLbl.text = StringDateFormatter.applyFormat(date: post.date)
        guard let topImageUrl = URL(string: post.pics[0]) else {
            return
        }
        cell.topImage.kf.setImage(with: topImageUrl)
        cell.setBottomImages(imageURLs: Array(post.pics[1..<post.pics.count]))
        cell.delegate = self
    }
    
    private func isFirstUserPost(row: Int) -> Bool {
        guard row > 0 else {
            return true
        }
        let currentPost = viewPosts?[row]
        let previousPost = viewPosts?[row - 1]
        return currentPost?.user.uid != previousPost?.user.uid
    }
    
}

// MARK: - Image selection delegate

extension ViewController: ImageSelectionDelegate {
    
    func imageWasSelected(image: UIImage) {
        popImage(image: image)
    }
    
}
