//
//  ChatUser.swift
//  Chat
//
//  Created by Bdriah Talaat on 04/06/1444 AH.
//

import Foundation
import FirebaseFirestoreSwift
import UIKit

struct ChatUser : Codable {
    let uid : String
    let email : String
    let profileImage : String
    let fullName : String
    @DocumentID var docID: String?
}
