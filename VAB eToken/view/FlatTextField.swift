//
//  FlatTextField.swift
//  VAB eToken
//
//  Created by Pham Huy on 6/9/20.
//  Copyright © 2020 Pham Huy. All rights reserved.
//

import UIKit

class FlatTextField: UITextField {

   override func layoutSubviews() {
        super.layoutSubviews()
        commonInit()
    }
    class func defaultDirection()-> UIRectEdge{
        return UIRectEdge.bottom
    }
    func commonInit(){
        inputView = UIView()
        if let placeholder = self.placeholder {
            self.attributedPlaceholder = NSAttributedString(string:placeholder,
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
        self.layer.addBorder(edge: UIRectEdge.bottom, color: self.tintColor, thickness: 0.5, margin: 0)
    }

}
