//
//  TransparentNavBar.swift
//  VAB eToken
//
//  Created by Pham Huy on 6/11/20.
//  Copyright © 2020 Pham Huy. All rights reserved.
//

import UIKit

class TransparentNavBar : UINavigationBar {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
        self.backgroundColor = .clear
        if #available(iOS 13.0, *) {
            self.standardAppearance.backgroundColor = .clear
            self.standardAppearance.backgroundEffect = .none
            self.standardAppearance.shadowColor = .clear
        }
    }
}
