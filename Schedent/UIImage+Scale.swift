//
//  UIImage+Scale.swift
//  Schedent
//
//  Created by Sriteja Thuraka on 7/3/17.
//  Copyright © 2017 Sriteja Thuraka. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    
    func scale(newWidth: CGFloat) -> UIImage {
        
        if self.size.width == newWidth {
            return self
        }
        // calculate the scale factor
        let scaleFactor = newWidth / self.size.width
        let newHeight = self.size.height * scaleFactor
        let newSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage : UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}
