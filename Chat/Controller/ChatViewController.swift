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
    var chatMessage = [ChatMessage]()

    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
       
        fetchMessage()
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
                
        nameLabel.text = chatUser?.fulName
        userImage.setImageFromStringURL(stringURL: chatUser!.profilrImage)
        userImage.setImageCircler(image: userImage)
        
      
       
    }
    
    //MARK: FUNCTIONS
    
    func fetchMessage(){

        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else{ return }
        guard let toId = chatUser?.fulName else{ return }

        FirebaseManager.shared.firestore.collection("Messages").document(fromId).collection(toId).order(by: "time").getDocuments { QuerySnapshot, Error in

            if let Error = Error{
                print(Error)
            }
            self.chatMessage = []

            if let snapshotDocuments = QuerySnapshot?.documents{
                
                for doc in snapshotDocuments {
                    
                    print(doc.data())
//                    let data = doc.data()
//                    let newMessage = ChatMessage.init(data: data)
//                    self.chatMessage.append(newMessage)
//
//                    DispatchQueue.main.async {
//                        self.chatTableView.reloadData()
//                    }
                }
            }
            
            QuerySnapshot?.documents.forEach({ snapshot in
                let data = snapshot.data()
                
                let fromId = data["fromId"] as? String ?? ""
                let toId = data["toId"] as? String ?? ""
                let text = data["text"] as? String ?? ""
                
                let chatMessage = ChatMessage(fromId: fromId, toId: toId, text: text)
                
                self.chatMessage.append(chatMessage)
                
            })
           
            
//           QuerySnapshot?.documents.forEach({ queryDocumentSnapshot in
//
//                let data = queryDocumentSnapshot.data()
//                self.chatMessage.append(.init( data: data))
//
//                print(self.chatMessage.count)
//                DispatchQueue.main.async{
//
//                }
//
//            })
        }
    }
    
    //MARK: ACTIONS
    @IBAction func sendButton(_ sender: Any) {
       
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else{ return }
        guard let toId = chatUser?.email else{ return }

        let senderMessageDocument = FirebaseManager.shared.firestore.collection("Messages").document(fromId).collection(toId).document()
        let chatText = messageTextField.text
        
        let messageData = [ "fromId" : fromId , "text": chatText , "toId":toId , "timestamp":MTLTimestamp(),"time" : Date().timeIntervalSince1970 ] as [String : Any]
        
        
        senderMessageDocument.setData(messageData){ [self] error in
            
            if let error = error{
                print(error)
            }else{
                
                DispatchQueue.main.async{
                    self.messageTextField.text = ""
                    self.chatTableView.reloadData()
                    
//                    let indexPath = IndexPath(row: self.chatMessage.count-1, section: 0)
//                    self.chatTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
        
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("Messages").document(toId).collection(fromId).document()
        
        recipientMessageDocument.setData(messageData){ error in
            
            if let error = error{
                print(error)
            }else{
                DispatchQueue.main.async{
//                    self.messageTextField.text = ""
//                    self.chatTableView.reloadData()
//
//                    let indexPath = IndexPath(row: self.chatMessage.count-1, section: 0)
//                    self.chatTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
    }
    
    @IBAction func mediaButton(_ sender: Any) {
    }
    
    @IBAction func backButton(_ sender: Any) {
       
        let vc = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        vc.chatUser += [chatUser!]
        print(vc.chatUser.count)
        present(vc, animated: false)
        
    }
}
//MARK: ECTENTION
extension ChatViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(chatMessage.count)
        return chatMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        let data = chatMessage[indexPath.row]
        
        
        cell.messageLabel.text = data.text
        cell.messageView.setCircler(value: 5, View: cell.messageView)
        
        print(data.text)
        return cell
    }
     

}


