//
//  SingleImageCell.swift
//  Argon
//
//  Created by Armando Brito on 3/14/21.
//

import UIKit

class SingleImageCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImg.layer.cornerRadius = profileImg.bounds.height / 2
    }

}
