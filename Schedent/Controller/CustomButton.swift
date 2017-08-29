//
//  CustomButton.swift
//  Schedent
//
//  Created by Sriteja Thuraka on 7/2/17.
//  Copyright © 2017 Sriteja Thuraka. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {

  
        @IBInspectable var cornerRadius : CGFloat = 0.0 {
            
            didSet {
                layer.cornerRadius = cornerRadius
                layer.masksToBounds = cornerRadius > 0
                
            }
        }
        @IBInspectable var borderWidth : CGFloat = 0.0 {
            didSet {
                layer.borderWidth = borderWidth
                
            }
            
        }
        @IBInspectable var borderColor : UIColor = .black {
            
            didSet {
                
                layer.borderColor = borderColor.cgColor
            }
        }
        @IBInspectable var titleLeftPadding : CGFloat = 0.0  {
            
            didSet {
                
                titleEdgeInsets.left = titleLeftPadding
            }
        }
        @IBInspectable var titleRightPadding : CGFloat = 0.0  {
            
            didSet {
                
                titleEdgeInsets.right = titleRightPadding
            }
        }
        @IBInspectable var titleTopPadding : CGFloat = 0.0  {
            
            didSet {
                
                titleEdgeInsets.top = titleTopPadding
            }
        }
        @IBInspectable var titleBottomPadding : CGFloat = 0.0  {
            
            didSet {
                
                titleEdgeInsets.bottom = titleBottomPadding
            }
        }
        @IBInspectable var imageLeftpadding : CGFloat = 0.0 {
            
            didSet {
                
                imageEdgeInsets.left = imageLeftpadding
            }
        }
        @IBInspectable var imageRightpadding : CGFloat = 0.0 {
            
            didSet {
                
                imageEdgeInsets.right = imageRightpadding
            }
        }
        @IBInspectable var imageToppadding : CGFloat = 0.0 {
            
            didSet {
                
                imageEdgeInsets.top = imageToppadding
            }
        }
        @IBInspectable var imageBottompadding : CGFloat = 0.0 {
            
            didSet {
                
                imageEdgeInsets.bottom = imageBottompadding
            }
        }
        
        
    }



