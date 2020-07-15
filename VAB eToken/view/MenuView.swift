//
//  MenuView.swift
//  VAB eToken
//
//  Created by Pham Huy on 6/15/20.
//  Copyright © 2020 Pham Huy. All rights reserved.
//

import UIKit

class MenuView: UIViewController , UITableViewDelegate, UITableViewDataSource {
    var menuDelegate : MenuViewDelegate?
    var items : [MenuItem]?
    
    @IBOutlet weak var tblDataHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidAppear(_ animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items = menuDelegate?.onCreateMenu()
        return items?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let label = cell.viewWithTag(100) as? UILabel
        let menu = items?[indexPath.row]
        label?.text = menu?.menuTitle
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = items?[indexPath.row]{
            closeSlideMenuView()
            menuDelegate?.onMenuItemSelect(item: menu)
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= items!.count - 1 {
            DispatchQueue.main.async {
                self.tblDataHeightConstraint.constant = self.tableView.contentSize.height
            }
        }
       
    }
    func closeSlideMenuView(){
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
    @IBAction func closeButtonTouch(_ sender: Any) {
        closeSlideMenuView()
    }
    
}

class MenuItem {
    var menuCode : Int
    var menuTitle : String
    init(_ code : Int,_ title : String) {
        menuCode = code
        menuTitle = title
    }
}


protocol MenuViewDelegate {
    func onMenuItemSelect(item : MenuItem)
    func onCreateMenu()->[MenuItem]?
}
