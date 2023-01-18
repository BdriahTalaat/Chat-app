//
//  Chat Message.swift
//  Chat
//
//  Created by Bdriah Talaat on 16/06/1444 AH.
//

import Foundation

struct FirebaseConestants {
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
}

struct ChatMessage /*: Identifiable*/{
    let fromId : String
    let toId : String
    let text : String
    //let documentId : String
    //var id : String { documentId }
    
    
    init(/*documentId:String ,*/ data:[String:Any]){
        self.fromId = data[FirebaseConestants.fromId] as? String ?? ""
        self.toId = data[FirebaseConestants.toId] as? String ?? ""
        self.text = data[FirebaseConestants.text] as? String ?? ""
        //self.documentId = documentId
    }

}
