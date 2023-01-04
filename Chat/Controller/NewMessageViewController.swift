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
    var users = [ChatUser]()
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersTableView.delegate = self
        usersTableView.dataSource = self
       
        fetchAllUser()
    }
    
    //MARK: ACYIONS
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    //MARK: FUNCTIONS
    
    /// allow fetch all user from firebase
    func fetchAllUser(){
        
        FirebaseManager.shared.firestore.collection("user").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                querySnapshot?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    
                    let uid = data["uid"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let profilrImage = data["profile Image URL"] as? String ?? ""
                    let fulName = data["Full name"] as? String ?? ""
                    let chatUser = ChatUser.init(uid: uid, email: email, profilrImage: profilrImage, fullName: fulName)
                    
                    self.users.append(chatUser)
                    
                })
                usersTableView.reloadData()

            }
        }
        
    }
}
//MARK: EXTENTION
extension NewMessageViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewUserTableViewCell", for: indexPath) as! NewUserTableViewCell
        var data = users[indexPath.row]

        cell.nameLabel.text = data.fullName
        cell.userImage.setImageFromStringURL(stringURL: data.profilrImage)
        cell.userImage.setImageCircler(image: cell.userImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = users[indexPath.row]
        
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
