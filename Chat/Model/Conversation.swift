//
//  Conversation.swift
//  Chat
//
//  Created by Bdriah Talaat on 11/06/1444 AH.
//

import Foundation
import FirebaseFirestoreSwift

struct Conversation: Identifiable, Codable {
   
    @DocumentID var docID: String?
    let id = UUID()
    let users: [String]
    var messages: [Message] = []
    var lastMessage: Message? {
        return messages.last
    }
}

struct Message: Identifiable, Codable {
    let id = UUID()
    let text: String
    let senderID: String
    let timestamp: Date
}

//struct Users {
//    let me : ChatUser
//    let other : ChatUser
//}
//
//struct ChatUser {
//    let uid : String
//    let email : String
//    let profilrImage : String
//    let fullName : String
//}

