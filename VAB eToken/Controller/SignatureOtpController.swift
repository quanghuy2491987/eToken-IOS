//
//  SignatureOtpController.swift
//  VAB eToken
//
//  Created by Pham Huy on 6/11/20.
//  Copyright © 2020 Pham Huy. All rights reserved.
//

import UIKit

class SignatureOtpController: BaseViewController , QRScannerDelegate {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var txtOtp: UILabel!
    @IBOutlet weak var btCopy: UIButton!
    @IBOutlet weak var btQrScan: UIButton!
    @IBOutlet weak var txtTransCode: UITextField!
    @IBOutlet weak var txtCountDown: UILabel!
    
    var timer : Timer?
    
    override func viewDidLoad() {    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        configView()
    }
    func getOtp() {
        let transCode = txtTransCode.text
        if transCode == nil || transCode == "" {
            txtOtp.text = ""
            txtCountDown.text = ""
            return
        }
        let token = Provisioning_Logic.token(FakeAppData.provision_KEY())
        if token == nil {
            reInstall()
            return
        }
        let pin = self.appDelegate.pin
        if pin == nil || pin == "" {
            logOut()
            return
        }
        let pinInput = appDelegate.secureString(pin!)
        
        let otp = try? OTP_Logic.generateOtp(token, with: pinInput, withTransCode: transCode)
        txtOtp.text = otp?.otp.stringValue()!
        startCountDown(lifeSpan: otp!.lifespan)
        otp?.wipe()
        pinInput.wipe()
    }
    
    func startCountDown(lifeSpan : Lifespan){
        var secondsRemaining = lifeSpan.current
        self.txtCountDown.text = "Mã OTP sẽ tự động cập nhật trong vòng \(secondsRemaining) giây"
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if secondsRemaining > 0 {
                self.txtCountDown.text = "Mã OTP sẽ tự động cập nhật trong vòng \(secondsRemaining) giây"
                secondsRemaining -= 1
            } else {
                if let timer = self.timer {
                    timer.invalidate()
                    self.timer = nil
                    self.getOtp()
                }
            }
        }
    }
    func configView(){
        let origImage = UIImage(named: "copy_icon")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        btCopy.setImage(tintedImage, for: .normal)
        btCopy.tintColor = txtOtp.textColor
        
        let qrImage = UIImage(named: "qrcode")
        let qrTint = qrImage?.withRenderingMode(.alwaysTemplate)
        btQrScan.setImage(qrTint, for: .normal)
        btQrScan.tintColor = txtOtp.textColor
        
        topView.radiusBottom(isBottom: false, radius: 20)
        bottomView.radiusBottom(isBottom: true, radius: 20)
        addDoneButtonOnKeyboard()
        txtTransCode.becomeFirstResponder()
    }
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Get OTP", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        txtTransCode.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(){
        txtTransCode.endEditing(true)
        getOtp()
    }
    
    @IBAction func copyTouch(_ sender: Any) {
        UIPasteboard.general.string = txtOtp.text
        let url = URL(string: "vabmobilebanking:view?code=\(txtOtp.text ?? "")")
               
        UIApplication.shared.open(url!) { (result) in
            if result {
               // The URL was delivered successfully!
            }
        }
    }
    @IBAction func qrTouch(_ sender: Any) {
        QRScannerController.setupQrScanner(context: self)
    }
    func onScannerComplete(_ result: String) -> Bool {
        if result != "" {
            txtTransCode.text = result
            txtTransCode.endEditing(true)
            getOtp()
        }
        return true
    }
    
}
