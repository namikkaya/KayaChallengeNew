//
//  cityInput.swift
//  KayaChallengeNew
//
//  Created by Nok Danışmanlık on 3.01.2020.
//  Copyright © 2020 brokoly. All rights reserved.
//

import UIKit

protocol cityInputDelegate:class {
    /**
    Usage:  Aranmak istenen string i getirir
    - Parameter searchString:  Aranacak String
    - Returns: No return value
    */
    func cityInputActionEvent(searchString:String?)
}

extension cityInputDelegate {
    /**
     Usage:  Aranmak istenen string i getirir
     - Parameter searchString:   Aranacak String
     - Returns: No return value
     */
    func cityInputActionEvent(searchString:String?){}
}

@IBDesignable
class cityInput: UIView, UITextFieldDelegate {
//    MARK: - Basic
    private var view:UIView!
    private var nibName:String = "cityInput"
    
//    MARK: - Objects
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var inputText: kayaCustomTextField!
    
//    MARK: - Delegate
    weak var delegate:cityInputDelegate?
    
//    MARK: - Variable
    
    /// Text arka plan rengini belirler
    @IBInspectable
    var textContainerColor:UIColor = UIColor.lightGray{
        didSet{
            inputText.bgColor = textContainerColor
        }
    }
    
    /// Text ve button kıvrığı değeri
    @IBInspectable
    var objectRadius:CGFloat = CGFloat(8) {
        didSet{
            inputText.objectRadius = objectRadius
            searchButton.layer.cornerRadius = objectRadius
        }
    }
    
    /// Button arka plan rengi
    @IBInspectable
    var buttonColor:UIColor = UIColor.blue {
        didSet{
            searchButton.backgroundColor = buttonColor
        }
    }
    
    /// place holder rengi
    @IBInspectable
    var placeHolderColor:UIColor = UIColor.darkGray {
        didSet {
            inputText.placeHolderColor = placeHolderColor
        }
    }
    
    /// inputText border color
    @IBInspectable
    var inputTextBorderColor:UIColor = UIColor.black {
        didSet {
            inputText.borderColor = inputTextBorderColor
        }
    }
    
    /// inputText border width
    @IBInspectable
    var inputTextBorderWidth:CGFloat = 1 {
        didSet {
        inputText.borderWidth = inputTextBorderWidth
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
        configuration()
    }
    
    func loadViewFromNib()-> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    private func configuration() {
        inputText.adjustsFontSizeToFitWidth = true
        inputText.minimumFontSize = 17
        inputText.delegate = self
        
        searchButton.titleLabel?.minimumScaleFactor = 1
        searchButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    
//    MARK: - Button Events
    @IBAction func searchButtonEvent(_ sender: Any) {
        sendData(string: inputText.text)
    }
    
//    MARK: - inputText -> Textfield delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var allowed = CharacterSet()
        allowed.formUnion(.lowercaseLetters)
        allowed.formUnion(.uppercaseLetters)
        allowed.formUnion(.whitespaces)
        //let characterSet = "abcçdefgğhiıjklmnoöpqrsştuüvwxyzABCÇDEFGHIİJKLMNOÖPQRSŞTUÜVWXYZ "
        if string.rangeOfCharacter(from: allowed/*CharacterSet(charactersIn:characterSet)*/) != nil || string.isEmpty {
            return true
        }else {
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == inputText {
            textField.resignFirstResponder()
            sendData(string: inputText.text)
        }
        return false
    }
    
    
    private func sendData(string:String?){
        if let string = string {
            var trimmedStr = string.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedStr == "" {
                trimmedStr = "İstanbul"
            }
            inputText.text = ""
            delegate?.cityInputActionEvent(searchString: trimmedStr)
        }
    }
}

