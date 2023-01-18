//
//  ResetPasswordViewController.swift
//  Chat
//
//  Created by Bdriah Talaat on 24/06/1444 AH.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var emailView: UIView!
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        emailView.setCircler(value: 5, View: emailView)
        sendView.setCircler(value: 5, View: sendView)
        
    }
    //MARK: ACTIONS
    @IBAction func sendButton(_ sender: Any) {
        FirebaseManager.shared.auth.sendPasswordReset(withEmail: emailTextField.text!){error in
            if let error = error{
                let alert = UIAlertController.init (title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default ,handler: { action in
                    self.emailTextField.text = ""
                }))
                
                self.present(alert, animated: false)
            }else{
                let alert = UIAlertController.init (title: "Hurray", message:"A password reset email has been send!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default , handler: { action in
                    self.dismiss(animated: false)
                }))
                
                self.present(alert, animated: false)
                
            }
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: false)
    }
    
}
