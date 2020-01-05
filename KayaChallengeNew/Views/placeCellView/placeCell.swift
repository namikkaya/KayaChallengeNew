//
//  placeCell.swift
//  KayaChallengeNew
//
//  Created by Nok Danışmanlık on 4.01.2020.
//  Copyright © 2020 brokoly. All rights reserved.
//

import UIKit

class placeCell: UICollectionViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.contentView.frame = bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override func layoutSubviews() {
       contentView.superview?.frame = bounds
       super.layoutSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup(data:venues?) {
        if let data = data {
            if let title = data.name {
                titleLabel.text = title
            }
            if let city = data.location?.city {
                locationLabel.text = city
            }
            if data.detail != nil  {
                if let rating = data.detail?.rating, let ratingColor = data.detail?.ratingColor {
                    ratingLabel.text = String(rating)
                    ratingLabel.textColor = UIColor.init(hexString: "#\(ratingColor)")
                }
            }else {
                ratingLabel.text = "?"
                ratingLabel.textColor = UIColor.darkGray
            }
        }
    }
    
    var bottomLine:CALayer?
    override func layoutSublayers(of layer: CALayer) {
        addBottomBorder()
    }
    
    private func addBottomBorder () {
        self.contentView.frame = bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if bottomLine != nil {
            bottomLine?.removeFromSuperlayer()
            bottomLine = nil
        }
        
        bottomLine = CALayer()
        bottomLine!.frame = bounds
        bottomLine?.frame.size.height = 0.5
        bottomLine?.frame.size.width = (bottomLine?.frame.size.width)! - 20
        bottomLine?.frame.origin.x = 20
        bottomLine?.frame.origin.y = self.bounds.size.height - (bottomLine?.frame.size.height)!*2
        
        bottomLine?.backgroundColor = UIColor.lightGray.cgColor
        
        self.layer.addSublayer(bottomLine!)
        
    }
    
}
