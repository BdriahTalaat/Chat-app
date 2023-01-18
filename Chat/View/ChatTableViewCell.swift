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
    @IBOutlet weak var messageTimeLabel: UILabel!
    @IBOutlet weak var imageMessage: UIImageView!
    @IBOutlet weak var messageDateLabel: UILabel!
    
    var conversation: Conversation!
    //MARK: LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(messageFromOther), name: NSNotification.Name("messageFromOther"), object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func messageFromOther(){

        messageTimeLabel.isHidden = true
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: 330).isActive = true
        messageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        messageView.backgroundColor = .darkGray
        
    }
}
