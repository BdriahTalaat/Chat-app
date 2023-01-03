//
//  convert image.swift
//  Chat
//
//  Created by Bdriah Talaat on 06/06/1444 AH.
//

import Foundation
import UIKit

extension UIImageView{
    
    func setImageFromStringURL(stringURL:String){
        if let imageURL = URL(string: stringURL){
            if let imageData = try? Data(contentsOf: imageURL){
                self.image = UIImage(data: imageData)
            }
        }
    }
    
    func setImageCircler(image:UIImageView){
        image.layer.cornerRadius = image.frame.width/2
    }
    
}
