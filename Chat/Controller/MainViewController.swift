//
//  MainViewController.swift
//  Chat
//
//  Created by Bdriah Talaat on 29/05/1444 AH.
//

import UIKit
import Firebase

class MainViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var logInView: UIView!
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if FirebaseManager.shared.auth.currentUser?.uid != nil{
//            let vc = storyboard?.instantiateViewController(withIdentifier: "UsersViewController") as! UsersViewController
//
//            present(vc, animated: false)
//        }
        
        signUpView.setCircler(value: 4, View: signUpView)
        signUpView.setShadow(View: signUpView, shadowRadius: 5, shadowOpacity: 0.4, shadowOffsetWidth: 4, shadowOffsetHeight: 4)
        logInView.setCircler(value: 4, View: logInView)
        logInView.setShadow(View: logInView, shadowRadius: 5, shadowOpacity: 0.4, shadowOffsetWidth: 4, shadowOffsetHeight: 4)
    }

    //MARK: ACTION
    @IBAction func LogInButtom(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        present(vc, animated: false)
    }
    
    @IBAction func SignUpButtom(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        present(vc, animated: false)
    }


}
