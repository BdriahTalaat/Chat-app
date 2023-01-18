//
//  ChatManager.swift
//  Chat
//
//  Created by Bdriah Talaat on 11/06/1444 AH.
//

import Foundation
import Firebase

final class ChatManager {
    
    static let shared = ChatManager()
    
    var conversations: [Conversation] = []
    var users: [ChatUser] = []
    var didUpdateConversation: () -> () = {}
    
    public func delete(id:Int , _ completion: @escaping () -> ()){
   
        guard let data = ChatManager.shared.conversations[id].docID else { return }

        FirebaseManager.shared.firestore.collection("conversations").document(data).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                completion()
            }
        }

    }
    
        // create conversations
    public func create(withID: String, _ completion: @escaping () -> ()) {
        guard let userID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        Task {
            do {
                let snapshot = try await FirebaseManager.shared.firestore.collection("conversations")
                    .whereField("users", isEqualTo: [userID, withID]).getDocuments()
                //print("^^^", snapshot.count)
                if snapshot.count > 0 {
                    // conversation exists
                    return
                }
                
                let conversation = Conversation(users: [userID, withID])
                let _ = try FirebaseManager.shared.firestore.collection("conversations").addDocument(from: conversation)
                
                listen {
                    completion()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    public func getUsers() async {
        do {
            guard let userID = FirebaseManager.shared.auth.currentUser?.uid else { return }
            let snapshot = try await FirebaseManager.shared.firestore.collection("user").getDocuments(source: .server)
            self.users = try snapshot.documents.map { try $0.data(as: ChatUser.self) }
        } catch {
             print(error.localizedDescription)
        }
    }
    
    public func getUserData(uid: String) -> ChatUser? {
        if let user = users.first(where: { $0.uid == uid }) {
            return user
        }
        return nil
    }
    
    public func getUserData(uid: String) async -> ChatUser? {
        if let user = users.first(where: { $0.uid == uid }) {
            return user
        } else {
            do {
              
                let snapshot = try await FirebaseManager.shared.firestore.collection("user")
                    .whereField("uid", isEqualTo: uid).getDocuments(source: .server)
                if let user = try snapshot.documents.first?.data(as: ChatUser.self) {
                    return user
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        return nil
    }
    
    public func listen(_ completion: @escaping () -> ()) {
        guard let userID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        Task {
            await getUsers()
            do {
                let snapshot = try await FirebaseManager.shared.firestore.collection("conversations")
                    .whereField("users", arrayContains: userID).getDocuments(source: .server)
                self.conversations = try snapshot.documents.map { try $0.data(as: Conversation.self) }
                
                var usersIDs: [String] = []
                
                conversations.forEach { conversation in
                    if let uid = conversation.users.filter ({ $0 != userID }).first {
                        if !usersIDs.contains(uid) {
                            usersIDs.append(uid)
                        }
                    }
                }
                
                for uid in usersIDs {
                    if let user = await getUserData(uid: uid) {
                        if !self.users.contains(where: { $0.uid == user.uid }) {
                            self.users.append(user)
                        }
                    }
                }
                
                // listen to messages ( To allow appear message from me and other in the same time )
                
                for conversation in conversations {
                    guard let docID = conversation.docID else { return }
                    
                    FirebaseManager.shared.firestore.collection("conversations").document(docID).collection("messages").addSnapshotListener { snapshot, error in
                        if let documents = snapshot?.documents {
                            do {
                                
                                var messages: [Message] = try documents.map { try $0.data(as: Message.self) }
                                messages.sort { $0.timestamp < $1.timestamp }
                                
                                if let index = self.conversations.firstIndex(where: { $0.id == conversation.id }) {
                                    self.conversations[index].messages = messages
                                    self.didUpdateConversation()
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                            
                        }
                    }
                }
                completion()
            }
        }
    }
    
    public func send(conversation: Conversation, message: Message) {
        guard let docID = conversation.docID else { return }
       
        do {
            _ = try FirebaseManager.shared.firestore.collection("conversations").document(docID).collection("messages").addDocument(from: message)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    // update data for user
    public func updateData(name:String , email:String){
        
        let userEmail = FirebaseManager.shared.auth.currentUser?.email
        let currentUser = FirebaseManager.shared.auth.currentUser
        
        for user in users{
            guard let docId = user.docID else {return}
            
            if user.email == userEmail{
                
                if name != nil && email != nil{
                   
                    FirebaseManager.shared.firestore.collection("user").document(docId).updateData(["email" : email , "fullName" :name])
                    if email != userEmail{
                        currentUser?.updateEmail(to: email){error in
                            if let  error = error{
                                print(error.localizedDescription)
                            }
                        }
                    }

                }else{
                    print("error")
                }
            }
        }
    }
}
