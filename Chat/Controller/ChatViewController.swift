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
    //var chatMessage = [ChatMessage]()
    var imageMessage = false
    var imageChat : UIImageView?
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        let otherID: String = conversation.users.filter { $0 != FirebaseManager.shared.auth.currentUser!.uid }.first!
        var userData: ChatUser? = ChatManager.shared.getUserData(uid: otherID)
        
        nameLabel.text = userData!.fullName
        userImage.setImageFromStringURL(stringURL: userData!.profileImage)
        userImage.setImageCircler(image: userImage)
        
        ChatManager.shared.didUpdateConversation = {
            
            self.chatTableView.reloadData()
        }
        
    }
    
    //MARK: FUNCTIONS
    
    
//    func getDesignMessage(user: Any){
//        if let index = ChatManager.shared.conversations.firstIndex(where: { $0.id == conversation.id }){
//            let uid = FirebaseManager.shared.auth.currentUser!.uid
//            let data = ChatManager.shared.conversations[index].messages.first
//
//            if uid != data?.senderID{
//                
//            }
//        }
//
//    }

    func getPhoto(type : UIImagePickerController.SourceType){
       
        /// allow user chose image from your images
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = type
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true)
    }
    
    
    //MARK: ACTIONS
    @IBAction func sendButton(_ sender: Any) {
       
        if messageTextField.text != nil{
           
            guard let conversation = conversation else { return }
            guard let text = messageTextField.text else { return }
            guard let userID = FirebaseManager.shared.auth.currentUser?.uid else { return }
            
            let message = Message(text: text, senderID: userID, timestamp: Date())
            
            ChatManager.shared.send(conversation: conversation, message: message)
            
            messageTextField.text = ""
        }
        
//        if imageChat != nil {
//            imageChat?.setImageFromStringURL(stringURL: <#T##String#>)
//        }
    }
    

    
    @IBAction func mediaButton(_ sender: Any) {
        
        imageMessage = true
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default , handler: { action in
           self.getPhoto(type: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo & Video Library", style: UIAlertAction.Style.default, handler: { action in
            self.getPhoto(type: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cencel", style: UIAlertAction.Style.cancel))
        
        present(alert, animated: true)
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
       
        return ChatManager.shared.conversations[index].messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print(#function)
        if let index = ChatManager.shared.conversations.firstIndex(where: { $0.id == conversation.id }) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
            let data = ChatManager.shared.conversations[index].messages[indexPath.row]
            let uid = FirebaseManager.shared.auth.currentUser!.uid
            
            
            if uid != data.senderID{
                
                //NotificationCenter.default.post(name: NSNotification.Name("messageFromOther"), object: nil)
                
                //cell.messageView.viewConstraint(View: cell.messageView)
            }
            
            // NotificationCenter.default.removeObserver(self, name: NSNotification.Name("messageFromOther"), object: nil)
            cell.messageDateLabel.setCircler(value: 5, View: cell.messageDateLabel)
            cell.messageDateLabel.text = "\(Calendar.current.component(.month, from: data.timestamp)) \(Calendar.current.component(.day, from: data.timestamp)) "
            
            cell.messageTimeLabel.text = "\(Calendar.current.component(.hour, from: data.timestamp)) : \(Calendar.current.component(.minute, from: data.timestamp))"
            cell.messageLabel.text = data.text
            cell.messageView.setCircler(value: 5, View: cell.messageView)
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
//            let data = chatMessage[indexPath.row]
//
//
//            cell.messageLabel.text = data.text
//            cell.messageView.setCircler(value: 5, View: cell.messageView)
//
//            print(data.text)
//            return cell
//        }
    }
     

}
extension ChatViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info [UIImagePickerController.InfoKey.editedImage] as! UIImage
        dismiss(animated: true)
        
        if imageMessage == false{
            userImage.image = image
        }else{
            //userImage.image = image
            imageChat?.image = image
        }
        
    }
}


