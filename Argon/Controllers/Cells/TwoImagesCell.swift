//
//  TwoImagesCell.swift
//  Argon
//
//  Created by Armando Brito on 3/16/21.
//

import UIKit

class TwoImagesCell: UITableViewCell, PostCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImg.layer.cornerRadius = profileImg.bounds.height / 2
    }
    
}
