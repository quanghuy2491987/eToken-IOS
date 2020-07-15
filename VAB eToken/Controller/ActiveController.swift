//
//  ActiveController.swift
//  VAB eToken
//
//  Created by Pham Huy on 6/9/20.
//  Copyright © 2020 Pham Huy. All rights reserved.
//

import UIKit

class ActiveController: BaseViewController , GenericHandler{
   
    @IBOutlet weak var pinInout: PinInputView!
    @IBOutlet weak var txtActiveCode: FlatTextField!
    @IBOutlet weak var btActive: RadiusButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        conmonConfig()
    }
    
    func conmonConfig(){
        pinInout.maxLenght = 0
        pinInout.setupEditField(editField: txtActiveCode)
    }
    
    @IBAction func onActive(_ sender: Any) {
        let clearRegCode = txtActiveCode.text
        if clearRegCode == nil || clearRegCode == "" {
            alertError("Vui lòng nhập mã kích hoạt", nil)
        }
        let regCode = EMCore.sharedInstance()?.secureContainerFactory()?.secureString(from: clearRegCode)
        Provisioning_Logic.provision(withUserId: FakeAppData.provision_KEY(), registrationCode: regCode!, completionHandler: {token, error in
            regCode?.wipe()
            if (token != nil) {
                self.onFinished(success: true, result: "")
            } else if (error != nil) {
                self.onFinished(success: false, result: error!.localizedDescription)
            } else {
                self.onFinished(success: false, result: "Không thể kích hoạt, vui lòng thử lại.")
            }
        })
        
    }
    
    
    func onFinished(success: Bool, result: String) {
        if !success {
            alertError(result, nil)
        } else {
            alertError("Kích hoạt thành công.", UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: {action in
                self.openViewControllerBasedOnIdentifier("CreatePassController", nil, true)
            }))
        }
    }
}
