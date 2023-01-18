//
//  NewMessageViewController.swift
//  Chat
//
//  Created by Bdriah Talaat on 06/06/1444 AH.
//

import UIKit

class NewMessageViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var usersTableView: UITableView!
    
    //MARK: VARIABLE
    //var users = [ChatUser]()
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersTableView.delegate = self
        usersTableView.dataSource = self
       
        //fetchAllUser()
    }
    
    //MARK: ACYIONS
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    //MARK: FUNCTIONS
    
    
}
//MARK: EXTENTION
extension NewMessageViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return 0 }
        return ChatManager.shared.users.filter { $0.uid != uid }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewUserTableViewCell", for: indexPath) as! NewUserTableViewCell
        let uid = FirebaseManager.shared.auth.currentUser!.uid
        var data = ChatManager.shared.users.filter { $0.uid != uid }[indexPath.row]

        //var userData: ChatUser? = ChatManager.shared.getUserData(uid: data.uid)
        
        cell.nameLabel.text = data.fullName
        cell.userImage.setImageFromStringURL(stringURL: data.profileImage)
        cell.userImage.setImageCircler(image: cell.userImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = ChatManager.shared.users[indexPath.row]
        print(selectedIndex.fullName)
        ChatManager.shared.create(withID: selectedIndex.uid) {
            let conversation = ChatManager.shared.conversations.first(where: { $0.users.contains(selectedIndex.uid) })
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            
            vc.conversation = conversation
            
            DispatchQueue.main.async {
                self.present(vc, animated: false)
            }
            
        }
        
    }
}
