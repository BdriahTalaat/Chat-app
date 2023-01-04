//
//  ChatViewController.swift
//  Chat
//
//  Created by Bdriah Talaat on 07/06/1444 AH.
//

import UIKit


class ChatViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    //MARK: VARIABLEA
    var chatUser : ChatUser?
    var conversation: Conversation!
    var chatMessage = [ChatMessage]()
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        //let chat = ChatManager.shared.conversations[index(ofAccessibilityElement: 0)].users.first
        //nameLabel.text = chat
        
        //        print(chatUser?.fullName)
////        userImage.setImageFromStringURL(stringURL: chatUser!.profilrImage)
//        userImage.setImageCircler(image: userImage)
        
        ChatManager.shared.didUpdateConversation = {
            print("update")
            self.chatTableView.reloadData()
        }
        
      
       
    }
    
    //MARK: FUNCTIONS

    
    //MARK: ACTIONS
    @IBAction func sendButton(_ sender: Any) {
       
        guard let conversation = conversation else { return }
        guard let text = messageTextField.text else { return }
        guard let userID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let message = Message(text: text, senderID: userID, timestamp: Date())
        ChatManager.shared.send(conversation: conversation, message: message)

    }
    
    @IBAction func mediaButton(_ sender: Any) {
    }
    
    @IBAction func backButton(_ sender: Any) {
       
        let vc = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController

        present(vc, animated: false)
        
    }
}
//MARK: ECTENTION
extension ChatViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // print(chatMessage.count)
        guard let index = ChatManager.shared.conversations.firstIndex(where: { $0.id == conversation.id }) else { return 0 }
        print(ChatManager.shared.conversations[index].messages.count)
        return ChatManager.shared.conversations[index].messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#function)
        if let index = ChatManager.shared.conversations.firstIndex(where: { $0.id == conversation.id }) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
            let data = ChatManager.shared.conversations[index].messages[indexPath.row]
            
            cell.messageLabel.text = data.text
            cell.messageView.setCircler(value: 5, View: cell.messageView)
            
            
            print("cell")
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
            let data = chatMessage[indexPath.row]
            
            
            cell.messageLabel.text = data.text
            cell.messageView.setCircler(value: 5, View: cell.messageView)
            
            print(data.text)
            return cell
        }
    }
     

}


