//
//  PinInputView.swift
//  VAB eToken
//
//  Created by Pham Huy on 6/8/20.
//  Copyright © 2020 Pham Huy. All rights reserved.
//

import UIKit


class PinInputView: UIView, UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var editText : UITextField?
    var pinDelegate : PinInputDelegate?
    
    let MAX_SIZE : CGFloat = 70
    let MIN_SIZE : CGFloat = 40
    
    var size : CGFloat = 0
    public static let deleteText : String = "Xóa"
    let arrayString = [["1","2","3"],["4","5","6"],["7","8","9"],["","0",deleteText]]
    
    var maxLenght: Int = 6
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func setupEditField(editField : UITextField){
        editText = editField
        editText?.inputView = UIView()
        editText?.becomeFirstResponder()
        
    }
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed("PinInputView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        initCollectionView()
    }
    
    private func initCollectionView() {
        let nib = UINib(nibName: "PinCellView", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "pinCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return arrayString.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayString[1].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pinCell", for: indexPath) as? PinCellView else {
            fatalError("can't dequeue CustomCell")
        }
        
        let data = arrayString[indexPath.section][indexPath.row]
        cell.label.text = data
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 2.0
        cell.layer.cornerRadius = cell.frame.width / 2
        cell.layer.masksToBounds = true
        cell.backgroundColor = .white
        if data == "" {
            cell.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 20 * 2) / 3
        let height = (collectionView.frame.height - 10 * 3) / 4
        size = width
        if(height > width){
            size = width
        } else {
            size = height
        }
        if(size > MAX_SIZE){
            size = MAX_SIZE
        } else if(size < MIN_SIZE){
            size = MIN_SIZE
        }
        return CGSize(width: size, height: size)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let viewHeight: CGFloat = collectionView.frame.height
        let viewWidth = collectionView.frame.width
        let contentHeight: CGFloat = size * 4 + 10 * 3
        let contentWidth : CGFloat = size * 3 + 20 * 2
        let marginHeight: CGFloat = (viewHeight - contentHeight) * 2/3
        let marginLeft : CGFloat = (viewWidth - contentWidth) / 2
        if (section == 0) {
            return UIEdgeInsets(top: marginHeight, left: marginLeft, bottom:  0, right: marginLeft)
        } else {
            return UIEdgeInsets(top: 10, left: marginLeft, bottom:  0, right: marginLeft)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let text = arrayString[indexPath.section][indexPath.row]
        if text != "" {
            if(text == PinInputView.deleteText){
                delChar()
            } else {
                addChar(char: text)
            }
        }
    }
    
    func addChar(char : String){
        if editText?.text?.count ?? 0 >= maxLenght && maxLenght > 0 {
            pinDelegate?.onTextInputComplete(editText: editText, text: editText?.text ?? "")
        } else {
            var text = editText?.text ?? ""
            text += char
            editText?.text = text
            if editText?.text?.count ?? 0 >= maxLenght && maxLenght > 0 {
                pinDelegate?.onTextInputComplete(editText: editText, text: editText?.text ?? "")
            }
        }
    }
    func delChar(){
        var text = editText?.text ?? ""
        let lenght = text.count
        if (lenght > 0) {
            let index = text.index(text.startIndex,offsetBy: text.count - 1)
            text = String(text[..<index])
            editText?.text = text
        } else {
            pinDelegate?.onTextInputClear(editText: editText)
        }
    }
}

public protocol PinInputDelegate {
    func onTextInputComplete(editText : UITextField?, text : String)
    func onTextInputClear(editText : UITextField?)
}
