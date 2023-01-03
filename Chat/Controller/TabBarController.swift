//
//  TabBarController.swift
//  Chat
//
//  Created by Bdriah Talaat on 30/05/1444 AH.
//

import UIKit

class TabBarController: UITabBarController {

    //MARK: VARIABLES
    var chatUser : [ChatUser] = []
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        let vc = viewControllers![0] as! UsersViewController
        vc.user = chatUser
        print(chatUser.count)
    }
    

}
