
import UIKit

class TabBaseViewController: UITabBarController, MenuViewDelegate {
    
    
    private var progressLoading : ProgressView?
    public var Data : Any?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButtonIcon()
        setRightButtonIcon()
    }
    
    @IBAction func onBackButtonPressed(_ sender : UIButton?){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onRightButtonPressed(_ sender : UIButton?){
        openMenu()
    }
    
    func setBackButtonIcon(){
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 30, height: 30)
        menuBtn.setImage(UIImage(named:"back"), for: .normal)
        menuBtn.addTarget(self, action: #selector(onBackButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        menuBarItem.tag = 99
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 30)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 25)
        currHeight?.isActive = true
        self.navigationItem.leftBarButtonItem = menuBarItem
    }
    
    func setRightButtonIcon(){
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 30, height: 30)
        menuBtn.setImage(UIImage(named:"menu"), for: .normal)
        menuBtn.addTarget(self, action: #selector(onRightButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        menuBarItem.tag = 100
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 30)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 25)
        currHeight?.isActive = true
        if self.navigationItem.rightBarButtonItem?.tag != 100 {
            self.navigationItem.rightBarButtonItem = menuBarItem
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        
    }
    func setBackgroundImage(_ imageName : String){
        self.view.backgroundColor = UIColor.clear
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: imageName)?.draw(in: self.view.bounds)
        if let image: UIImage = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        } else{
            UIGraphicsEndImageContext()
        }
        
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String , _ data: Any?, _ clearTop : Bool = false){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destViewController : UIViewController = storyboard.instantiateViewController(withIdentifier: strIdentifier)
        destViewController.modalPresentationStyle = .fullScreen
        destViewController.title = self.title
        if destViewController is BaseViewController {
            (destViewController as? BaseViewController)?.Data = data
        }
        if self.navigationController != nil {
            if clearTop {
                
                UIView.transition(with: self.appDelegate.window!, duration: 0.5, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: {
                    self.navigationController?.viewControllers = [destViewController]
                    //self.appDelegate.window?.rootViewController = self.navigationController
                }, completion: nil)
            } else {
                if self.navigationController?.topViewController != destViewController {
                    self.navigationController!.pushViewController(destViewController, animated: true)
                }
            }
        } else {
            if destViewController is UINavigationController {
                if let topview = (destViewController as! UINavigationController).topViewController {
                    if topview is BaseViewController {
                        
                    }
                }
            }
            self.present(destViewController, animated: true, completion: nil)
        }
        self.dismissLoadProgress()
    }
    
    func displayLoadProgress(){
        DispatchQueue.main.async {
            self.view.endEditing(true)
            if self.progressLoading == nil {
                self.progressLoading = ProgressView(frame: (UIApplication.shared.keyWindow?.frame)!)
                UIApplication.shared.keyWindow?.addSubview(self.progressLoading!)
                
            } else {
                self.progressLoading?.frame = (UIApplication.shared.keyWindow?.frame)!
                self.progressLoading?.layoutIfNeeded()
            }
        }
        self.progressLoading?.startAnimating()
    }
    
    func dismissLoadProgress(){
        DispatchQueue.main.async {
            self.progressLoading?.stopAnimating()
        }
    }
    
    func alertError(_ message: String, _ action : UIAlertAction?) {
        
        let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        if(action != nil){
            alert.addAction(action!)
        } else {
            alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    @objc func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.1, animations: {()-> Void in
            self.view.frame.origin.y = 0
            self.view.layoutIfNeeded()
        })
    }
    
    func findActiveTextField(in subviews: [UIView], textField : inout UIView?){
        guard textField == nil else { return }
        for view in subviews {
            if let tf = view as? UITextField, view.isFirstResponder {
                textField = tf
                break
            } else if let tf = view as? UITextView, view.isFirstResponder {
                textField = tf
                break
            }
            else if !view.subviews.isEmpty {
                findActiveTextField(in: view.subviews, textField: &textField)
            }
        }
    }
    
    func findScrollView(in subviews: [UIView], scrollView : inout UIView?){
        guard scrollView == nil else {return}
        for view in subviews {
            switch view {
            case _ as UILabel, _ as UITextField, _ as UIButton , _ as UIStackView, _ as UIImageView :
                break
            case _ as UIScrollView :
                scrollView = view
                break
            default:
                if !view.subviews.isEmpty {
                    findScrollView(in: view.subviews, scrollView: &scrollView)
                }
            }
        }
        
    }
    func onCreateMenu() -> [MenuItem]? {
        let menus = [MenuItem(0,"Đổi mật khẩu"), MenuItem(1, "Xóa token")]
        return menus
    }
    func onMenuItemSelect(item: MenuItem) {
        switch item.menuCode {
        case 0:
            changePin()
            break
        case 1:
            reInstall()
            break
        default:
            break
        }
    }
    func openMenu(){
        
        guard let menu = self.view.viewWithTag(99) else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rightMenu : MenuView = storyboard.instantiateViewController(withIdentifier: "MenuView") as! MenuView
            rightMenu.view.tag = 99
            rightMenu.menuDelegate = self
            self.view.insertSubview(rightMenu.view, belowSubview: self.tabBar) 
            self.addChildViewController(rightMenu)
            rightMenu.view.layoutIfNeeded()
            
            
            rightMenu.view.frame=CGRect(x:  0, y: -UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width , height: UIScreen.main.bounds.size.height);
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                rightMenu.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width , height: UIScreen.main.bounds.size.height);
                
            }, completion:nil)
            return
        }
        menu.removeFromSuperview()
        
    }
    
    func changePin(){
        openViewControllerBasedOnIdentifier("LoginController", 1,false)
    }
    func logOut(){
        appDelegate.pin = nil
        openViewControllerBasedOnIdentifier("LoginController", nil, true)
    }
    func reInstall(){
        try? Provisioning_Logic.removeToken()
        appDelegate.resetReference()
        openViewControllerBasedOnIdentifier("HomeController", nil, true)
    }
    
    func creatPinProgress(){
        openViewControllerBasedOnIdentifier("CreatePassController", nil, true)
    }
}
