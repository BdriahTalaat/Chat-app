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
}

extension UITextView {
    func setCircler(value:CGFloat , View:UITextView){
        View.layer.cornerRadius = View.frame.height / value
    }
}
