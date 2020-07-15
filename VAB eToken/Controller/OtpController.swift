//
//  OtpController.swift
//  VAB eToken
//
//  Created by Pham Huy on 6/11/20.
//  Copyright © 2020 Pham Huy. All rights reserved.
//

import UIKit

class OtpController: BaseViewController {
    
    var tabBar : UITabBarController? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    func configView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        tabBar = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.view.addSubview(tabBar!.view);
        self.addChildViewController(tabBar!)
        onCallApp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .didCallApp, object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(onCallApp), name: .didCallApp, object: nil)
        
    }
    
    @objc func onCallApp() {
        if let arrayUrl = appDelegate.callBackContent {
            if arrayUrl.count > 1 {
                var type = "c"
                var data = ""
                for url in arrayUrl {
                    if url.name == "type" {
                        type = url.value ?? "c"
                    }
                    if url.name == "data" {
                        data = url.value ?? ""
                    }
                }
                if type.lowercased() == "c" {
                    tabBar?.selectedIndex = 0
                }
                else {
                    tabBar?.selectedIndex = 1
                    if let signature = tabBar?.viewControllers?[1] as? SignatureOtpController {
                        signature.txtTransCode.text = data
                        signature.getOtp()
                    }
                }
            }
        }
    }
    
}
