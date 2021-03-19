//
//  PostCell.swift
//  Argon
//
//  Created by Armando Brito on 3/16/21.
//

import UIKit

protocol PostCell: UITableViewCell {
    
    var userSection: UIView! { get set }
    var userSectionHeight: NSLayoutConstraint! { get set }
    var profileImg: UIImageView! { get set }
    var userNameLbl: UILabel! { get set }
    var userEmailLbl: UILabel! { get set }
    var dateLbl: UILabel! { get set }
    
    func omitUserSection(_ omit: Bool)
    
}

// MARK: - Default implementation

extension PostCell {
    
    func omitUserSection(_ omit: Bool) {
        userSection.isHidden = omit
        userSectionHeight.constant = omit ? 0.0 : Constants.userSectionHeight
    }
    
}
