//
//  CreatePassControllerViewController.swift
//  VAB eToken
//
//  Created by Pham Huy on 6/11/20.
//  Copyright © 2020 Pham Huy. All rights reserved.
//

import UIKit

class CreatePassController: BaseViewController , PinInputDelegate{
    
    @IBOutlet weak var txtNewPass: FlatTextField!
    @IBOutlet weak var txtReNewPass: FlatTextField!
    @IBOutlet weak var btAccept: RadiusButton!
    @IBOutlet weak var pinInput: PinInputView!
    var type : Int? = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func configView(){
        type = self.Data as? Int
        if type == nil {
            type = 0
        }
        
        pinInput.setupEditField(editField: txtNewPass)
        pinInput.pinDelegate = self
        
        
    }
    
    @IBAction func newPassEdit(_ sender: Any) {
        pinInput.setupEditField(editField: txtNewPass)
    }
    
    @IBAction func renewpassEdit(_ sender: Any) {
        pinInput.setupEditField(editField: txtReNewPass)
    }
    @IBAction func acceptTouch(_ sender: Any) {
        if type == 0 {
            doCreatePin()
        } else {
            doChangePin()
        }
    }
    
    func onTextInputComplete(editText: UITextField?, text: String) {
        if editText == txtNewPass {
            pinInput.setupEditField(editField: txtReNewPass)
        }
        if editText == txtReNewPass {
            if type == 0 {
                doCreatePin()
            } else {
                doChangePin()
            }
            
        }
    }
    func onTextInputClear(editText: UITextField?) {
        if editText == txtReNewPass {
            pinInput.setupEditField(editField: txtNewPass)
        }
    }
    
    func doChangePin(){
       let token = Provisioning_Logic.token(FakeAppData.provision_KEY())
        if token == nil {
            reInstall()
        }
        let oldPin = appDelegate.pin
        if oldPin == nil {
            self.logOut()
        }
        let newPin = txtNewPass.text
        let reNewPin = txtReNewPass.text
        if newPin?.count != pinInput.maxLenght && pinInput.maxLenght != 0 {
            alertError("Mật khẩu phải có độ dài là \(pinInput.maxLenght)", nil)
            return
        }
        if newPin == nil || newPin == "" {
            alertError("Quý khách vui lòng nhập mật khẩu mới.", nil)
            return
        }
        if reNewPin == nil || reNewPin == "" {
            alertError("Quý khách vui lòng nhập lại mật khẩu.", nil)
            return
        }
        
        let ref = ChangePin_Logic.changePin(token, oldPin: appDelegate.secureString(oldPin!), newPin: appDelegate.secureString(newPin!), newPinConfirm: appDelegate.secureString(reNewPin!))
        
        if ref == FakeAppData.pin_DIFFERENT() {
            txtNewPass.text = nil
            txtReNewPass.text = nil
            pinInput.setupEditField(editField: txtNewPass)
            alertError("Mật khẩu không giống nhau. Quý khách vui lòng kiểm tra lại.", nil)
        } else if ref == FakeAppData.pin_SUCCESS() {
            self.appDelegate.saveReference(key: FakeAppData.pin_KEY(), data: newPin!)
            logOut()
        } else {
            txtNewPass.text = nil
            txtReNewPass.text = nil
            pinInput.setupEditField(editField: txtNewPass)
            alertError(ref ?? "", nil)
        }
        
    }
    func doCreatePin(){
        let token = Provisioning_Logic.token(FakeAppData.provision_KEY())
        if token == nil {
            reInstall()
        }
        let oldPin = "123456"
        let newPin = txtNewPass.text
        let reNewPin = txtReNewPass.text
        if newPin?.count != pinInput.maxLenght && pinInput.maxLenght != 0 {
            alertError("Mật khẩu phải có độ dài là \(pinInput.maxLenght)", nil)
            return
        }
        if newPin == nil || newPin == "" {
            alertError("Quý khách vui lòng nhập mật khẩu mới.", nil)
            return
        }
        if reNewPin == nil || reNewPin == "" {
            alertError("Quý khách vui lòng nhập lại mật khẩu.", nil)
            return
        }
        
        let ref = ChangePin_Logic.changePin(token, oldPin: appDelegate.secureString(oldPin), newPin: appDelegate.secureString(newPin!), newPinConfirm: appDelegate.secureString(reNewPin!))
        
        if ref == FakeAppData.pin_DIFFERENT() {
            txtNewPass.text = nil
            txtReNewPass.text = nil
            pinInput.setupEditField(editField: txtNewPass)
            alertError("Mật khẩu không giống nhau. Quý khách vui lòng kiểm tra lại.", nil)
        } else if ref == FakeAppData.pin_SUCCESS() {
            self.appDelegate.saveReference(key: FakeAppData.pin_KEY(), data: newPin!)
            logOut()
        } else {
            txtNewPass.text = nil
            txtReNewPass.text = nil
            pinInput.setupEditField(editField: txtNewPass)
            alertError(ref ?? "", nil)
        }
        
    }
    
}
