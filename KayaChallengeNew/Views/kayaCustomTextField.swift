//
//  kayaCustomTextField.swift
//  KayaChallengeNew
//
//  Created by Nok Danışmanlık on 4.01.2020.
//  Copyright © 2020 brokoly. All rights reserved.
//

import UIKit

class kayaCustomTextField: UITextField {

    var innerShadow:CALayer?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 0
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1.5
        self.backgroundColor = UIColor.blue
        self.tintColor = UIColor.darkGray
        addInnerShadow()
    }
    private func addInnerShadow() {
        if innerShadow != nil {
            innerShadow?.removeFromSuperlayer()
            innerShadow = nil
        }
        innerShadow = CALayer()
        innerShadow!.frame = bounds

        let radius:CGFloat = 8
        let path = UIBezierPath(roundedRect: innerShadow!.bounds.insetBy(dx: -1, dy: -1), cornerRadius:radius)
        let cutout = UIBezierPath(roundedRect: innerShadow!.bounds, cornerRadius:radius).reversing()

        path.append(cutout)
        innerShadow!.shadowPath = path.cgPath
        innerShadow!.masksToBounds = true
        innerShadow!.shadowColor = UIColor.black.cgColor
        innerShadow!.shadowOffset = CGSize(width: 0, height: 0.5)
        innerShadow!.shadowOpacity = 0.8
        innerShadow!.shadowRadius = 2
        innerShadow!.cornerRadius = 8
        layer.addSublayer(innerShadow!)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        addInnerShadow()
    }
    
    var objectRadius:CGFloat = CGFloat(8) {
        didSet{
            self.layer.cornerRadius = objectRadius
        }
    }
    
    var borderColor:UIColor = UIColor.darkGray {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    var borderWidth :CGFloat = 1 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    var bgColor:UIColor = UIColor.white {
        didSet {
            self.backgroundColor = bgColor
        }
    }
    
    var fontColor:UIColor = UIColor.black {
        didSet {
            self.tintColor = fontColor
        }
    }
    
    var placeHolderColor = UIColor.lightGray {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: (self.placeholder != nil) ? self.placeholder! : "Şehir giriniz", attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
        }
    }
}
