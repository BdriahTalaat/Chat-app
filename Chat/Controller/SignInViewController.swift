//
//  SignInViewController.swift
//  Chat
//
//  Created by Bdriah Talaat on 29/05/1444 AH.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class SignInViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signInButtomView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailView: UIView!
   
    //MARK: LIFE CICLE
    override func viewDidLoad() {
        super.viewDidLoad()

        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailView.setCircler(value: 5, View: emailView)
        passwordView.setCircler(value: 5, View: passwordView)
        signInButtomView.setCircler(value: 5, View: signInButtomView)
        signInButtomView.setShadow(View: signInButtomView, shadowRadius: 5, shadowOpacity: 0.4, shadowOffsetWidth: 4, shadowOffsetHeight: 4)
        //passwordView.setShadow(View: passwordView, shadowRadius: 5, shadowOpacity: 0.4, shadowOffsetWidth: 4, shadowOffsetHeight: 4)
        //emailView.setShadow(View: emailView, shadowRadius: 5, shadowOpacity: 0.4, shadowOffsetWidth: 4, shadowOffsetHeight: 4)
        
        
    }
    
    //MARK: ACTION
    
    @IBAction func forgetPasswordButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
        present(vc, animated: false)
    }
    
    @IBAction func signInButtom(_ sender: Any) {
        
        if let email = emailTextField.text{
            if let password = passwordTextField.text{

                Auth.auth().signIn(withEmail: email, password: password) { user, error in

                    if user != nil{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                        // setup chat listener
                        ChatManager.shared.listen {
                            DispatchQueue.main.async {
                                self.present(vc, animated: false)
                            }
                            
                        }
                        
                    }else{
                        if let Error = error{
                            let alert = UIAlertController.init(title: "Error", message: "\(Error.localizedDescription)", preferredStyle: .alert)

                            let OkAction = UIAlertAction(title: "OK", style: .default){ [self]_ in
                                passwordTextField.text = ""
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
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: false)
    }
    
    @IBAction func signUpButtom(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        
        present(vc, animated: false)
    }

}
//MARK: EXTENTION
extension SignInViewController : UITextFieldDelegate{
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }else{
            view.endEditing(true)
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

