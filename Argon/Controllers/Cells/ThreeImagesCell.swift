//
//  ThreeImagesCell.swift
//  Argon
//
//  Created by Armando Brito on 3/16/21.
//

import UIKit

class ThreeImagesCell: UITableViewCell, PostCell {

    var tapGestures: [UITapGestureRecognizer]!
    var delegate: ImageSelectionDelegate?
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var bottomLeftImg: UIImageView!
    @IBOutlet weak var bottomRightImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImg.layer.cornerRadius = profileImg.bounds.height / 2
        
        tapGestures = [UITapGestureRecognizer]()
        setupImagesTap()
    }
    
    private func setupImagesTap() {
        setupImageTap(topImage)
        setupImageTap(bottomLeftImg)
        setupImageTap(bottomRightImg)
    }
    
    private func setupImageTap(_ imageView: UIImageView) {
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageWasSelected(_:)))
        imageView.addGestureRecognizer(tapGesture)
        tapGestures.append(tapGesture)
    }
    
    @objc func imageWasSelected(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        delegate?.imageWasSelected(image: imageView.image!)
    }
    
}
