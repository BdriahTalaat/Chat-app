//
//  UserTableViewCell.swift
//  Chat
//
//  Created by Bdriah Talaat on 07/06/1444 AH.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    //MARK: OUTLETS
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
   
    //MARK: LIFE CICLE
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
