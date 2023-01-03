//
//  ChatViewController.swift
//  Chat
//
//  Created by Bdriah Talaat on 29/05/1444 AH.
//

import UIKit
import FirebaseAuth
import Firebase

class UsersViewController: UIViewController {

    //MARK: OOUTLETS
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var listUsersTableView: UITableView!
    @IBOutlet weak var newView: UIView!
    
    //MARK: VARIABLE
    @Published var chatUser : ChatUser?
    var user = [ChatUser]()
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
      
        listUsersTableView.reloadData()
        listUsersTableView.dataSource = self
        listUsersTableView.delegate = self
        
        getData()
        userImage.setImageCircler(image: userImage)
        newView.setCircler(value: 2, View: newView)
        newView.setShadow(View: newView, shadowRadius: 8, shadowOpacity: 0.5, shadowOffsetWidth: 2, shadowOffsetHeight: 2)

    }
    
    //MARK: ACTIONS
    @IBAction func NewMessageButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewMessageViewController") as! NewMessageViewController
        
        present(vc, animated: true)
    }
    
    //MARK: FUNCTIONS

    func getData(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        FirebaseManager.shared.firestore.collection("user").document(uid).getDocument { [self] querySnapshot, Error in

            if let error = Error{
                print(error)
            }

            guard let data = querySnapshot?.data() else {
                print(Error)
                return

            }

            let uid = data["uid"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let profilrImage = data["profile Image URL"] as? String ?? ""
            let fulName = data["Full name"] as? String ?? ""
            let chatUser = ChatUser.init(uid: uid, email: email, profilrImage: profilrImage, fulName: fulName)
            userNameLabel.text = fulName
            userImage.setImageFromStringURL(stringURL: profilrImage)
            print(fulName)

        }

    }
}
//MARK: EXTENTION
extension UsersViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        user.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        let data = user[indexPath.row]
        
        cell.nameLabel.text = data.fulName
        cell.userImage.setImageFromStringURL(stringURL: data.profilrImage)
        cell.userImage.setImageCircler(image: cell.userImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.chatUser = user[indexPath.row]
        present(vc, animated: false)
    }
}
