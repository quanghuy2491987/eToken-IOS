//
//  NormalOtpController.swift
//  VAB eToken
//
//  Created by Pham Huy on 6/11/20.
//  Copyright © 2020 Pham Huy. All rights reserved.
//

import UIKit

class NormalOtpController: BaseViewController {
    
    @IBOutlet weak var txtCountDown: UILabel!
    @IBOutlet weak var txtOtp: UILabel!
    @IBOutlet weak var btCopy: UIButton!
    
    var timer : Timer?
    override func viewDidLoad() {
        configView()
        getOtp()
        
    }
    func configView(){
        let origImage = UIImage(named: "copy_icon")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        btCopy.setImage(tintedImage, for: .normal)
        btCopy.tintColor = .white
    }
    
    func getOtp() {
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
        
        let otp = try? OTP_Logic.generateOtp(token, with: pinInput)
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
    
    @IBAction func copyTouch(_ sender: Any) {
        UIPasteboard.general.string = txtOtp.text
        let url = URL(string: "vabmobilebanking:view?code=\(txtOtp.text ?? "")")
               
        UIApplication.shared.open(url!) { (result) in
            if result {
               // The URL was delivered successfully!
            }
        }
    }
}
