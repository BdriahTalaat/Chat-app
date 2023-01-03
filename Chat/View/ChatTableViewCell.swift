//
//  ChatTableViewCell.swift
//  Chat
//
//  Created by Bdriah Talaat on 07/06/1444 AH.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    //MARK: OUTLETS
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
   
    
    //MARK: LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()

        
//        if FirebaseConestants.fromId == FirebaseManager.shared.auth.currentUser?.uid{
//            messageView.backgroundColor = .systemGray
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
