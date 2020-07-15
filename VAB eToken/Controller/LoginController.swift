//
//  LoginController.swift
//  VAB eToken
//
//  Created by Pham Huy on 6/11/20.
//  Copyright © 2020 Pham Huy. All rights reserved.
//

import UIKit

class LoginController: BaseViewController, PinInputDelegate {

    var type : Int? = 0
    @IBOutlet weak var txtPass: FlatTextField!
    @IBOutlet weak var pinInput: PinInputView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func configView(){
        type = self.Data as? Int
        if type == nil {
            type = 0
        }
        
        pinInput.setupEditField(editField: txtPass)
        pinInput.pinDelegate = self
    }
    
    func onTextInputComplete(editText: UITextField?, text: String) {
         doLogin()
    }
    func onTextInputClear(editText: UITextField?) {
        
    }
    
    func doLogin(){
        let savePin = appDelegate.getReference(key: FakeAppData.pin_KEY())
        if savePin == nil || savePin == "" {
            self.creatPinProgress()
            return
        }
        let pinInput = txtPass.text
        txtPass.text = nil
        if pinInput == nil || pinInput == "" {
            alertError("Quý khách vui lòng nhập mã pin.", nil)
            return
        }
        if checkLogin(pin: pinInput!) {
            self.appDelegate.login(pinInput)
            if type == 0 {
                self.openViewControllerBasedOnIdentifier("OtpController", nil)
            } else if type == 1 {
                self.openViewControllerBasedOnIdentifier("CreatePassController", nil)
            }
        } else {
            let pinCount = appDelegate.pinCount
            if pinCount >= 5 {
                alertError("Quý khách đã nhập sai mật khẩu \(pinCount) lần. Vì lý do bảo mật Quý khách vui lòng kích hoạt lại ứng dụng.", UIAlertAction(title: "Đóng", style: .default, handler: {Void in
                    self.reInstall()
                }))
            } else {
                alertError("Mật khẩu không chính xác.", nil)
            }
        }
    }

}
