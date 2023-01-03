//
//  DatabaseManager.swift
//  Chat
//
//  Created by Bdriah Talaat on 30/05/1444 AH.
//
//
import Foundation
import UIKit
import FirebaseStorage
import Firebase

class FirebaseManager : NSObject{
    
    let auth : Auth
    let storage : Storage
    let firestore : Firestore
    
    static let shared = FirebaseManager()
    
    
    override init() {
        //super.init()
        //FirebaseApp.configure()
        
        self.firestore = Firestore.firestore()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        
        
    }
    
    
}
