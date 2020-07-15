//
//  CameraFocusFinder.swift
//  VAB eToken
//
//  Created by Pham Huy on 6/23/20.
//  Copyright © 2020 Pham Huy. All rights reserved.
//

import Foundation
import UIKit

class CameraFocusFinder: UIView {
    
    var focusView : CAShapeLayer? = nil
    var focusFrame: CGRect? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        initView()
    }
    
    func initView(){
        self.backgroundColor = UIColor.black
        if focusView != nil {
            focusView?.removeFromSuperlayer()
        }
        
        focusView = createFrame()
        
    }
    func createFrame() -> CAShapeLayer {
        let height: Int = Int(self.frame.size.height)
        let width: Int = Int(self.frame.size.width)
        
        let marginLeft = 30
        let quareWidth = width - marginLeft*2
        let marginTop = Int((height - quareWidth) / 2)
        let quareLineWidth = 50
        let borderWidth: CGFloat = 4
        
        let path = UIBezierPath()
        //top left
        path.move(to: CGPoint(x: marginLeft, y: quareLineWidth + marginTop))
        path.addLine(to: CGPoint(x: marginLeft, y: marginTop))
        path.addLine(to: CGPoint(x: quareLineWidth + marginLeft, y: marginTop))
        
        //top right
        path.move(to: CGPoint(x: width  - (marginLeft + quareLineWidth), y: marginTop))
        path.addLine(to: CGPoint(x: width  - marginLeft, y: marginTop))
        path.addLine(to: CGPoint(x: width  - marginLeft, y: marginTop + quareLineWidth))
        
        //bottom left
        path.move(to: CGPoint(x: marginLeft, y: (marginTop+quareWidth) - quareLineWidth))
        path.addLine(to: CGPoint(x: marginLeft, y: quareWidth + marginTop))
        path.addLine(to: CGPoint(x: quareLineWidth + marginLeft, y: quareWidth + marginTop))
        
        //bottom right
        path.move(to: CGPoint(x: width  - (marginLeft + quareLineWidth), y: quareWidth + marginTop))
        path.addLine(to: CGPoint(x: width  - marginLeft, y: quareWidth + marginTop))
        path.addLine(to: CGPoint(x: width  - marginLeft, y: (marginTop+quareWidth) - quareLineWidth))
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.strokeColor = tintColor.cgColor
        shape.lineWidth = borderWidth
        shape.fillColor = UIColor.clear.cgColor
        shape.fillRule = kCAFillRuleEvenOdd
        
        self.backgroundColor =  UIColor.black.withAlphaComponent(0.6)
        //assume you work in UIViewcontroller
        
        
        let maskLayer = CALayer()
        maskLayer.frame = self.bounds
        let circleLayer = CAShapeLayer()
        //assume the circle's radius is 150
        circleLayer.frame = CGRect(x:0 , y:0,width: self.frame.size.width,height: self.frame.size.height)
        let finalPath = UIBezierPath(roundedRect: CGRect(x:0 , y:0,width: self.frame.size.width,height: self.frame.size.height), cornerRadius: 0)
        
        let rectPath = UIBezierPath(rect: CGRect(x:marginLeft + Int( borderWidth/2), y:marginTop +  Int( borderWidth/2), width: quareWidth - Int( borderWidth), height: quareWidth - Int( borderWidth)))
        finalPath.append(rectPath.reversing())
        circleLayer.path = finalPath.cgPath
        circleLayer.borderColor = UIColor.white.withAlphaComponent(1).cgColor
        circleLayer.borderWidth = 1
        maskLayer.addSublayer(circleLayer)
        focusFrame = path.bounds
        self.layer.mask = maskLayer
        self.layer.addSublayer(shape)
    
        return shape
    }
}
