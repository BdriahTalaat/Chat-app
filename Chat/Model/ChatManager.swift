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
    var didUpdateConversation: () -> () = {}
    
    public func create(withID: String, _ completion: @escaping () -> ()) {
        guard let userID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        Task {
            do {
                let snapshot = try await FirebaseManager.shared.firestore.collection("conversations")
                    .whereField("users", isEqualTo: [userID, withID]).getDocuments()
                print("^^^", snapshot.count)
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
    
    public func listen(_ completion: @escaping () -> ()) {
        guard let userID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        Task {
            do {
                let snapshot = try await FirebaseManager.shared.firestore.collection("conversations")
                    .whereField("users", arrayContains: userID).getDocuments(source: .server)
                self.conversations = try snapshot.documents.map { try $0.data(as: Conversation.self) }
                
                // listen to messages
                
                for conversation in conversations {
                    guard let docID = conversation.docID else { return }
                    FirebaseManager.shared.firestore.collection("conversations").document(docID).collection("messages").addSnapshotListener { snapshot, error in
                        if let documents = snapshot?.documents {
                            do {
                                var messages: [Message] = try documents.map { try $0.data(as: Message.self) }
                                messages.sort { $0.timestamp > $1.timestamp }
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
}
