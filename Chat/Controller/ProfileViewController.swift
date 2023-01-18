//
//  ProfileViewController.swift
//  Chat
//
//  Created by Bdriah Talaat on 30/05/1444 AH.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController{

    //MARK: OUTLETS
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var userNameLabel: UILabel!
    
    //MARK: VARIABLE
    
    
    
    
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        let uid = FirebaseManager.shared.auth.currentUser?.uid
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        //userNameLabel.text = uid.
    }
    //MARK: FUNCTIONS
    func signOut(){
       
        do{
            try Auth.auth().signOut()
            
        }catch let error{
            let alert = UIAlertController.init(title: "Error", message: "\(error)", preferredStyle: .actionSheet)

            let OkAction = UIAlertAction(title: "OK", style: .default )
            
            alert.addAction(OkAction)
            self.present(alert, animated: false)
        }
    }
    
    //MARK: ACTIONS
    @IBAction func signOutButton(_ sender: Any) {
        
        let alert = UIAlertController.init(title: "Sign Out", message: "Are you sure you want sign out", preferredStyle: .actionSheet)
        let OkAction = UIAlertAction(title: "Yes", style: .destructive) { action in
            
            self.signOut()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            self.present(vc, animated: false)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel )
        
        alert.addAction(OkAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: false)
      
    }
    
    @IBAction func EditPhotoButton(_ sender: Any) {
        let changePhotoAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        changePhotoAlert.addAction(UIAlertAction(title: "Take Photo", style: UIAlertAction.Style.default))
        changePhotoAlert.addAction(UIAlertAction(title: "Choose Photo", style: UIAlertAction.Style.default , handler: { action in
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        }))
        
        present(changePhotoAlert, animated: true)
    }
    
    @IBAction func editButton(_ sender: Any) {

        ChatManager.shared.updateData(name: nameTextField.text!, email: emailTextField.text!)
    }
}
//MARK: EXTENTION
extension ProfileViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info [UIImagePickerController.InfoKey.editedImage] as! UIImage
        dismiss(animated: true)
        profileImage.image = image
    }
}
