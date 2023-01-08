//
//  Make circler.swift
//  Chat
//
//  Created by Bdriah Talaat on 29/05/1444 AH.
//

import Foundation
import UIKit

extension UIView{
    func setCircler(value:CGFloat , View:UIView){
        View.layer.cornerRadius = View.frame.height / value
    }
    
    func setShadow(View:UIView , shadowRadius:CGFloat , shadowOpacity: Float , shadowOffsetWidth : Int , shadowOffsetHeight : Int){
        View.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 2)
        View.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        View.layer.shadowRadius = shadowRadius
        View.layer.shadowOpacity = shadowOpacity
    }
    
    func viewConstraint(View:UIView){
        
        View.translatesAutoresizingMaskIntoConstraints = false
        View.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: 330).isActive = true
        View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        View.backgroundColor = .darkGray
    }
}

extension UITextView {
    func setCircler(value:CGFloat , View:UITextView){
        View.layer.cornerRadius = View.frame.height / value
    }
}
//func messageFromOther(){
//
//    messageTimeLabel.isHidden = true
//    messageView.translatesAutoresizingMaskIntoConstraints = false
//    messageView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: 330).isActive = true
//    messageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
//    messageView.backgroundColor = .darkGray
//}
