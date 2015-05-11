//
//  CustomUILabel.swift
//  RottenTomatoes
//
//  Created by Baris Taze on 5/10/15.
//  Copyright (c) 2015 Baris Taze. All rights reserved.
//

import UIKit

// TODO: This is NOT IN USE. Delete later
class CustomUILabel: UILabel {

    override func drawTextInRect(rect: CGRect) {
        let insets = UIEdgeInsets(top:10, left:10, bottom:10, right:10)
        return super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
