//
//  SingleImageCell.swift
//  Argon
//
//  Created by Armando Brito on 3/14/21.
//

import UIKit

class SingleImageCell: UITableViewCell, PostCell {
    
    var delegate: ImageSelectionDelegate?
    
    @IBOutlet weak var userSection: UIView!
    @IBOutlet weak var userSectionHeight: NSLayoutConstraint!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImg.layer.cornerRadius = profileImg.bounds.height / 2
        
        mainImg.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mainImgWasSelected))
        mainImg.addGestureRecognizer(tapGesture)
    }
    
    @objc func mainImgWasSelected() {
        delegate?.imageWasSelected(image: mainImg.image!)
    }

}
