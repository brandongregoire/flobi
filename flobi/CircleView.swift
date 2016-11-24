//
//  CircleView.swift
//  flobi
//
//  Created by Brandon Gregoire on 2016-11-21.
//  Copyright © 2016 brandongregoire. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true 
    }
}
