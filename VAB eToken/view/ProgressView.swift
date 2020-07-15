//
//  ProgressView.swift
//  MobileBankingV2
//
//  Created by Pham Huy on 10/17/17.
//  Copyright © 2017 VietABank. All rights reserved.
//

import UIKit
import QuartzCore

class ProgressView: UIView {
    
    lazy private var animationLayer = CALayer()
    var overLayWindow : UIView?
    var isAnimating : Bool = false
    var hideWhenStopped : Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initialize(){
        backgroundColor = UIColor.clear
       // alpha = 0.4
        clipsToBounds = true
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        self.addSubview(loadingIndicator)
    }
    func startAnimating() {
        self.isHidden = false
    }
    
    func stopAnimating() {
        DispatchQueue.main.async {
           self.isHidden = true
        }
    }
    
}
