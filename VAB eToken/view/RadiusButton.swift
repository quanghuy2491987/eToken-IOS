//
//  RadiusButton.swift
//  MobileBankingV2
//
//  Created by Pham Huy on 10/21/17.
//  Copyright © 2017 VietABank. All rights reserved.
//

import UIKit


class RadiusButton: UIButton {

   
    override var tintColor: UIColor!{
        didSet {
            self.layer.borderColor = tintColor.cgColor
            self.titleLabel?.textColor = tintColor
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
       initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }
    func initialize(){
       self.layer.cornerRadius = 20
        if let color = self.tintColor {
            self.layer.borderColor = color.cgColor
           
        }
        let h : CGFloat = 20.0
        let top = (self.bounds.height - h) / 2
        self.imageEdgeInsets = UIEdgeInsets(top: top, left: 10, bottom: top, right: 10)
        self.imageView?.contentMode = .scaleAspectFit
        self.layer.masksToBounds = true
    }
   

}
