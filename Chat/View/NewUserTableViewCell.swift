//
//  UserTableViewCell.swift
//  Chat
//
//  Created by Bdriah Talaat on 07/06/1444 AH.
//

import UIKit

class NewUserTableViewCell: UITableViewCell {

    //MARK: OUTLETS
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    //MARK: LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
