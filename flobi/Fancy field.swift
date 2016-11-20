//
//  Fancy field.swift
//  flobi
//
//  Created by Brandon Gregoire on 2016-11-18.
//  Copyright © 2016 brandongregoire. All rights reserved.
//

import UIKit

class Fancy_field: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor(red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 0.2).cgColor
        layer.borderWidth = 1.0
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    
}
