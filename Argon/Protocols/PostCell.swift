//
//  PostCell.swift
//  Argon
//
//  Created by Armando Brito on 3/16/21.
//

import UIKit

protocol PostCell: UITableViewCell {
    var profileImg: UIImageView! { get set }
    var userNameLbl: UILabel! { get set }
    var userEmailLbl: UILabel! { get set }
    var dateLbl: UILabel! { get set }
}
