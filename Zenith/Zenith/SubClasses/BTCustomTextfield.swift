//
//  BTCustomTextfield.swift
//  BeanThere
//
//  Created by Neha Chhabra on 14/11/16.
//  Copyright © 2016 Neha Chhabra. All rights reserved.
//

import UIKit

class BTCustomTextfield: UITextField {

    let padding = UIEdgeInsets(top: 7, left: 6, bottom: 5, right: 0);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func drawPlaceholder(in rect: CGRect) {
        super.drawPlaceholder(in: rect)
        self.autocorrectionType = UITextAutocorrectionType.no
        let color = UIColor(red: 40/255.0, green: 40/255.0, blue: 40/255.0, alpha: 1.0)
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes: [NSForegroundColorAttributeName : color])
        self.font = UIFont.textBookFont(fontSize: 20)
        self.textAlignment = .center
    }
    
    open override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 26
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 198/255.0, green: 198/255.0, blue: 198/255.0, alpha: 1.0).cgColor
        self.layer.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0).cgColor
    }
}
