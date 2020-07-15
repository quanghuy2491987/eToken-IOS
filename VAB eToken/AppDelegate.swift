//
//  AppDelegate.swift
//  VAB eToken
//
//  Created by Pham Huy on 6/5/20.
//  Copyright © 2020 Pham Huy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var pin : String?
    var pinCount : Int = 0
    var pinService : EMPinAuthService?
    var window: UIWindow?
    var lastTimeAccess : Double = 0
    var backgroundTimeToExit = 60.0 // 300s = 5min
    var callBackContent : [URLQueryItem]? = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window?.makeKeyAndVisible()
        UITabBarItem.appearance().setTitleTextAttributes([ NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Bold", size: 17) as Any], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Bold", size: 17) as Any], for: .selected)
        
        lastTimeAccess = Date().timeIntervalSince1970
        
        configOtp()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        lastTimeAccess = Date().timeIntervalSince1970
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        //check if background time
        let currentTime = Date().timeIntervalSince1970
        if currentTime - lastTimeAccess >= self.backgroundTimeToExit {
            exit(0)
        } else {
            lastTimeAccess = currentTime
        }
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        var schemes = [String]()
        callBackContent = nil
        if let bundleURLTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [NSDictionary] {
            for bundleURLType in bundleURLTypes {
                if let scheme = bundleURLType["CFBundleURLSchemes"] {
                    if let streamArray = scheme as? [String] {
                        schemes += streamArray
                    }
                }
            }
        }
        
        schemes = schemes.map({ (s) -> String in
            return s.lowercased()
        })
        
        if ("error" == url.host) {
            print("error")
            return false
        }
        
        guard schemes.contains((url.scheme?.lowercased())!) else {
            print("unknown")
            return false
        }
        
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
            let albumPath = components.path,
            let params = components.queryItems else {
                print("Invalid URL or album path missing")
                return false
        }
        callBackContent = params
        NotificationCenter.default.post(name: .didCallApp, object: nil)
        return true
    }
    func configOtp(){
        if !EMCore.isConfigured() {
            let activationCode = FakeAppData.activationAllEnabled()
            let otpConfig = EMOtpConfiguration.default()
            let configs = Set<AnyHashable>([otpConfig])
            EMCore.configure(withActivationCode: activationCode, configurations: configs)
        }
        pinService = EMPinAuthService(module: EMAuthModule())
    }
    
    
    func getReference(key : String) -> String? {
        let defaults = UserDefaults.standard
        let data = defaults.string(forKey: key)
        return data
    }
    
    func resetReference(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: FakeAppData.provision_KEY())
        defaults.removeObject(forKey: FakeAppData.pin_KEY())
    }
    
    func saveReference(key : String, data : String){
        let defaults = UserDefaults.standard
        defaults.set(data, forKey: key)
    }
    
    func secureString(_ clearString : String) -> EMPinAuthInput {
        return try! pinService!.createAuthInput(with: clearString)
    }
    func login(_ pinInput : String?){
        self.pin = pinInput
    }
}

extension UIButton {
    public func addBorder(side: UIRectEdge, color: UIColor, width: CGFloat) {
        self.layer.masksToBounds = true
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.name = "\(side.rawValue)"
        self.layer.removeLayer(layerName: border.name)
        
        switch side {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        default:
            break
        }
        
        self.layer.addSublayer(border)
    }
}
extension CALayer {
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat, margin: CGFloat)-> CALayer {
        let border = CALayer()
        border.name = "\(edge.rawValue)"
        self.removeLayer(layerName: border.name)
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0 + margin,y: 0, width: self.frame.width - margin * 2, height: thickness)
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0 + margin,y: self.frame.height - thickness, width: self.frame.width - margin * 2, height: thickness)
        case UIRectEdge.left:
            border.frame = CGRect(x: 0,y: 0 + margin, width: thickness, height: self.frame.height - margin * 2)
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness  ,y: 0 + margin, width: thickness, height: self.frame.height - margin * 2)
        default:
            break
        }
        border.backgroundColor = color.cgColor
        self.masksToBounds = true
        self.addSublayer(border)
        return border
    }
    func removeLayer(layerName: String?) {
        for item in self.sublayers ?? [] where item.name == layerName {
            item.removeFromSuperlayer()
        }
    }
}

extension UIImage {
    public static func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
extension UIStackView {
    func setBackgroundColor(_ color: UIColor,_ isBottom: Bool, _ radius: CGFloat) {
        let backgroundView = UIView(frame: .zero)
        backgroundView.backgroundColor = color
        backgroundView.tintColor = color
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.radiusBottom(isBottom: isBottom, radius: radius)
        self.insertSubview(backgroundView, at: 0)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}

extension UIView {
    func radiusBottom(isBottom: Bool, radius: CGFloat){
        
        var path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: radius, height: radius))
        if isBottom {
            path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: radius, height: radius))
        }
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.borderColor = tintColor.cgColor
        self.layer.borderWidth = 1.0
        self.layer.mask = mask
    }
    
}
extension Notification.Name {
    static let didCallApp = Notification.Name("didCallApp")
}
