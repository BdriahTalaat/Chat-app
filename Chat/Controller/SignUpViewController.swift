//
//  SignUpViewController.swift
//  Chat
//
//  Created by Bdriah Talaat on 29/05/1444 AH.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class SignUpViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var signUpButtonView: UIView!
    @IBOutlet weak var paswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var paswordView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        paswordTextField.delegate = self
        nameTextField.delegate = self
        
        userImage.setImageCircler(image: userImage)
        
        nameView.setCircler(value: 5, View: nameView)
        emailView.setCircler(value: 5, View: emailView)
        paswordView.setCircler(value: 5, View: paswordView)
        signUpButtonView.setCircler(value: 5, View: signUpButtonView)
        signUpButtonView.setShadow(View: signUpButtonView, shadowRadius: 5, shadowOpacity: 0.4, shadowOffsetWidth: 4, shadowOffsetHeight: 4)
    }
    
    
    //MARK: ACTIONS
    @IBAction func backButtn(_ sender: Any) {
        dismiss(animated: false)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
        if let name = nameTextField.text{
            if let email = emailTextField.text{
                if let password = paswordTextField.text{
                   
                    Auth.auth().createUser(withEmail: email, password: password) { user, error in
                      
                        if user != nil{
                            
                            self.persisImageToStorage()
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                            self.present(vc, animated: false)
                            
                        }else{
                            if let Error = error{
                                let alert = UIAlertController.init(title: "Error", message: "\(Error.localizedDescription)", preferredStyle: .alert)
                                
                                let OkAction = UIAlertAction(title: "OK", style: .default){ [self]_ in
                                    paswordTextField.text = ""
                                    emailTextField.text = ""
                                    
                                }
                                alert.addAction(OkAction)
                                self.present(alert, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func signInButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        
        present(vc, animated: false)
    }
    
    @IBAction func addImageButton(_ sender: Any) {
       
        let changePhotoAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        changePhotoAlert.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default , handler: { [self] action in
            getPhoto(type: .camera)
        }))
        changePhotoAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel))
        changePhotoAlert.addAction(UIAlertAction(title: "Choose Photo", style: UIAlertAction.Style.default , handler: { [self] action in
            getPhoto(type: .photoLibrary)
        }))
        
        present(changePhotoAlert, animated: true)
    }
    
    //MARK: FUNCTIONS
    
    ///get photo
    func getPhoto(type : UIImagePickerController.SourceType){
       
        /// allow user chose image from your images
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = type
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true)
    }
    
    /// allow user to add image in firebase
    func persisImageToStorage(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        
        guard let imageData = self.userImage.image?.jpegData(compressionQuality: 0.5) else{ return }
        
        ref.putData(imageData,metadata: nil){ metadata, error in
            if let error = error{
               
                let alert = UIAlertController.init(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let OkAction = UIAlertAction(title: "OK", style: .default)
                
                alert.addAction(OkAction)
                self.present(alert, animated: false)
            }
            
            ref.downloadURL { url, error in
                if let error = error{
                    let alert = UIAlertController.init(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    let OkAction = UIAlertAction(title: "OK", style: .default)
                    
                    alert.addAction(OkAction)
                    self.present(alert, animated: false)
                }
                print("success")
                guard let url = url else{ return }
                self.storeUserInformation(imageProfileURL: url)
            }
        }
    }
    
    /// allow store user information in firebase storage
    func storeUserInformation(imageProfileURL:URL){
      
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{ return }
        
        let userData = ["email" : self.emailTextField.text , "uid" : uid , "profile Image URL" : imageProfileURL.absoluteString , "Full name" : self.nameTextField.text , "password" : self.paswordTextField.text] as [String : Any]
        
        FirebaseManager.shared.firestore.collection("user").document(uid).setData(userData){ error in
            if let error = error{
                print(error)
            }
            print("success")
        }
    }
    
}
//MARK: EXTENTION
extension SignUpViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info [UIImagePickerController.InfoKey.editedImage] as! UIImage
        dismiss(animated: true)
        userImage.image = image
    }
}

extension SignUpViewController : UITextFieldDelegate{
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField{
            emailTextField.becomeFirstResponder()
            
        }else if textField == emailTextField{
            paswordTextField.becomeFirstResponder()
            
        }else{
            view.endEditing(true)
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
