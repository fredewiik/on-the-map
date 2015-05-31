//
//  FormTextField.swift
//  On The Map
//
//  Created by Frédéric Lépy on 02/05/2015.
//  Copyright (c) 2015 Frédéric Lépy. All rights reserved.
//

import UIKit


@IBDesignable
class FormTextField: UITextField {
        
    @IBInspectable var inset: CGFloat = 0
    
        
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, inset, inset)
    }
    
        
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }

}
