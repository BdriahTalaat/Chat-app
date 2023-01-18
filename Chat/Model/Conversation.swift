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
    var id = UUID()
    let users: [String]
    var messages: [Message] = []
    var lastMessage: Message? {
        return messages.last
    }
}

struct Message: Identifiable, Codable {
    var id = UUID()
    let text: String
    let senderID: String
    let timestamp: Date
}

