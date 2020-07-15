//
//  PinCellView.swift
//  VAB eToken
//
//  Created by Pham Huy on 6/8/20.
//  Copyright © 2020 Pham Huy. All rights reserved.
//

import UIKit

class PinCellView: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private func commonInit(){
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
        self.backgroundColor = UIColor.white
        
    }
    
}
