//
//  HomeController.swift
//  VAB eToken
//
//  Created by Pham Huy on 6/11/20.
//  Copyright © 2020 Pham Huy. All rights reserved.
//

import UIKit

class HomeController: BaseViewController {
    
    override func viewDidLoad() {
        commonInit()
    }
    
    func commonInit(){
        if(EMJailbreakDetectorGetJailbreakStatus() == .jailbroken)
        {
            self.alertError("Thiết bị của bạn đã được jailbroken. Vì lý do bảo mật ứng dụng sẽ không thể chạy trên thiết bị này", UIAlertAction(title: "Đóng", style: .default, handler: { action in
                exit(0)
            }))
            return;
        }
        else{
            let token = Provisioning_Logic.token(FakeAppData.provision_KEY())
            if token == nil {
                clearAll()
                self.openViewControllerBasedOnIdentifier("ActiveController", nil, true)
            } else {
                let pin = self.appDelegate.getReference(key: FakeAppData.pin_KEY())
                if pin != nil && pin != "" {
                    self.openViewControllerBasedOnIdentifier("LoginController", nil,true)
                } else {
                    self.openViewControllerBasedOnIdentifier("CreatePassController",nil, true)
                }
            }
        }
    }
    
}
