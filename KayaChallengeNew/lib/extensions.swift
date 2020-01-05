//
//  extensions.swift
//  KayaChallengeNew
//
//  Created by Nok Danışmanlık on 4.01.2020.
//  Copyright © 2020 brokoly. All rights reserved.
//

import Foundation
import UIKit

private var dataAssocKey = 0
public var myHolderView:UIViewController?

extension UIViewController {
    var data:AnyObject? {
        get {
            return objc_getAssociatedObject(self, &dataAssocKey) as AnyObject?
        }
        set {
            objc_setAssociatedObject(self, &dataAssocKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /**
     Usage: Onaylatma bilgi alert
     - Parameter title:  Başlık
     - Parameter message:  Mesaj
     - Parameter positiveButtonTitle:  olumlu cevap button
     - Parameter negativeButtonTitle:  olumsuz cevap button / sadece bilgilendirme ise bu parametreye nil yollanırsa tek button olarak görüntülencek.
     - Parameter buttonClick: true / false
     - Returns: No return value
     */
    func informationAlert(title:String = "Başlık",
                          message:String = "Mesaj",
                          positiveButtonTitle:String = "Tamam",
                          negativeButtonTitle:String? = "İptal",
                          onButtonClick buttonClick: @escaping (Bool?) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: positiveButtonTitle, style: UIAlertAction.Style.default, handler: { (action) in
            buttonClick(true)
        }))
        if negativeButtonTitle != nil {
            alert.addAction(UIAlertAction(title: negativeButtonTitle, style: UIAlertAction.Style.cancel, handler: { (action) in
                buttonClick(false)
            }))
        }
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard_viewController))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard_viewController() {
        self.view.endEditing(true)
    }
    
    func goto(screenID:String,
              animated:Bool,
              data:AnyObject!,
              isModal:Bool,
              transition: UIViewControllerTransitioningDelegate) {
        let vc:UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: screenID))!
        myHolderView = vc
        if (data != nil) {
            vc.data = data
        }
        if isModal == true {
            vc.modalPresentationStyle = .overFullScreen//.overCurrentContext
            vc.transitioningDelegate = transition
            self.present(vc, animated: animated, completion:nil)
        }else {
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    /**
     Usage:  Özellikle preloader için kullanılır.
     - Parameter screenID:  viewcontroller storyboard id
     - Parameter animated:  true/false
     - Parameter color:  3 rent alır dıştan içe hareket
     - Parameter message:  açıklama satırı için string
     - Parameter transition:  Açılış kapanış animasyonu
     - Returns: No return value
     */
    func goto(screenID:String, animated:Bool, color:[UIColor], message:String? = "Yükleniyor...", transition: UIViewControllerTransitioningDelegate) {
        let vc:preloaderPopupController = (self.storyboard?.instantiateViewController(withIdentifier: screenID)) as! preloaderPopupController
        myHolderView = vc
        vc.modalPresentationStyle = .overFullScreen//.overCurrentContext
        vc.transitioningDelegate = transition
        vc.spinnerColor = color[0]
        vc.bSpinnerColor = color[1]
        vc.aSpinnerColor = color[2]
        vc.setDescription = message
        self.present(vc, animated: animated, completion:nil)
    }
    
    func back(animated:Bool, isModal:Bool) {
        myHolderView = nil
        if isModal == true {
            self.dismiss(animated: animated, completion: nil)
        }else {
            self.navigationController?.popViewController(animated: animated)
        }
    }
    
    func setNavigationColor(color:UIColor?){
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    /**
     Usage: ViewController için background rengi atar
     - Parameter color:  UIColor
     - Returns: No return value
     */
    func bgColor(color:UIColor) {
        self.view.backgroundColor = color
    }
    
    /**
     Usage:  NavigationController bar için title atar. Title için gölge efekti ve 17 size verir.
     - Parameter titleText:  String
     - Returns: No return value
     */
    func setNavigationBarTitle(titleText:String){
        let textShadow = NSShadow()
        textShadow.shadowBlurRadius = 1
        textShadow.shadowOffset = CGSize(width: 0.5, height: 0.5)
        textShadow.shadowColor = UIColor.gray
        
        var attrs:[NSAttributedString.Key : Any] = [:]
        if #available(iOS 8.2, *) {
            attrs = [
                /*NSAttributedString.Key.shadow: textShadow,*/
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
            ]
        } else {
            attrs = [
                /*NSAttributedString.Key.shadow: textShadow,*/
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)
            ]
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = attrs
        self.navigationItem.title = titleText
        
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension String {
    
    public func toInt() -> Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }

    public func toDouble() -> Double? {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }

    public func toFloat() -> Float? {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        } else {
            return nil
        }
    }
    
    public func toBool() -> Bool? {
        return (self as NSString).boolValue
    }
}

extension mainViewController {
//    MARK: - Keyboard Listener
    func observeKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func observeRemovekeyboardNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        
        if keyboardStatus == false{
            keyboardStatus = true
            lastKeyboardHeight = keyboardSize.height
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
            self.bottomConstraint.constant = (self.view.frame.height/2) - self.lastKeyboardHeight
            self.view.layoutIfNeeded()
        }) { (status) in
            
        }
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        
        if keyboardStatus == true && lastKeyboardHeight != keyboardSize.height {
            if lastKeyboardHeight < keyboardSize.height{
                let keyboardDifference: CGFloat = keyboardSize.height-lastKeyboardHeight
                UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
                    self.bottomConstraint.constant = (self.view.frame.height/2) - keyboardSize.height - keyboardDifference
                    self.view.layoutIfNeeded()
                }) { (status) in
                    
                }

            } else {
                let keyboardDifference: CGFloat = lastKeyboardHeight-keyboardSize.height
                UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
                    self.bottomConstraint.constant = (self.view.frame.height/2) - keyboardSize.height + keyboardDifference
                    self.view.layoutIfNeeded()
                }) { (status) in
                    
                }
            }
            lastKeyboardHeight = keyboardSize.height
        }
        
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let _ = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt

        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
            self.bottomConstraint.constant = self.bottomConstraintHolder
            self.view.layoutIfNeeded()
        }) { (status) in
                       
        }
    }
}

extension placeCollectionViewManager {
    
    internal func calSize()->CGSize?{
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            cellWidth = (collectionView!.frame.size.width)
            cellHeight = cellWidth * 0.3
            return CGSize(width: cellWidth, height: cellHeight)
        case .pad:
            cellWidth = (collectionView!.frame.size.width)/2 - 2
            cellHeight = cellWidth*0.3
            return CGSize(width: cellWidth, height: cellHeight)
        default:
            // telefon ayarlı
            cellWidth = (collectionView!.frame.size.width)
            cellHeight = cellWidth*0.3
            return CGSize(width: cellWidth, height: cellHeight)
        }
        
    }
}
/*
extension UIDevice {
    
    public class var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    public class var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
}
*/

extension UINavigationController {
    func pushToViewController(_ viewController: UIViewController, animated:Bool = true, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    func popViewController(animated:Bool = true, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: true)
        CATransaction.commit()
    }
    
    func popToViewController(_ viewController: UIViewController, animated:Bool = true, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popToViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    func popToRootViewController(animated:Bool = true, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popToRootViewController(animated: animated)
        CATransaction.commit()
    }
}
