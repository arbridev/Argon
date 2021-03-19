//
//  MoreImagesCell.swift
//  Argon
//
//  Created by Armando Brito on 3/16/21.
//

import UIKit

class MoreImagesCell: UITableViewCell, PostCell {
    
    private var bottomImages: [String]!
    var tapGesture: UITapGestureRecognizer!
    var delegate: ImageSelectionDelegate?

    @IBOutlet weak var userSection: UIView!
    @IBOutlet weak var userSectionHeight: NSLayoutConstraint!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImg.layer.cornerRadius = profileImg.bounds.height / 2
        
        collectionView.register(UINib(nibName: "\(BottomImageCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(BottomImageCell.self)")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        topImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageWasSelected))
        topImage.addGestureRecognizer(tapGesture)
    }
    
    func setBottomImages(imageURLs urls: [String]) {
        bottomImages = urls
        collectionView.reloadData()
    }
    
    @objc func imageWasSelected() {
        delegate?.imageWasSelected(image: topImage.image!)
    }
    
}

extension MoreImagesCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bottomImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(BottomImageCell.self)", for: indexPath) as! BottomImageCell
        if let imageURL = URL(string: bottomImages[indexPath.row]) {
            cell.contentImage.kf.setImage(with: imageURL)
        } else {
            fatalError()
        }
        return cell
    }
    
}

extension MoreImagesCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! BottomImageCell
        delegate?.imageWasSelected(image: cell.contentImage.image!)
    }
    
}
