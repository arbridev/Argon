//
//  ThreeImagesCell.swift
//  Argon
//
//  Created by Armando Brito on 3/16/21.
//

import UIKit

class ThreeImagesCell: UITableViewCell, PostCell {

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
    }
    
}
