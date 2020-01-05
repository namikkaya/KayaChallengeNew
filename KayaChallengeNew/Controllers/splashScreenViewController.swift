//
//  splashScreenViewController.swift
//  KayaChallengeNew
//
//  Created by Nok Danışmanlık on 5.01.2020.
//  Copyright © 2020 brokoly. All rights reserved.
//

import UIKit

class splashScreenViewController: UIViewController {
    let transition = splashScreenTransition()
    @IBOutlet var logoImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImage.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 1.9, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.logoImage.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { (act) in
            UIView.animate(withDuration: 0.4
                , delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                    self.logoImage.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    self.logoImage.alpha = 0.1
                    //self.view.layoutIfNeeded()
            }) { (act) in
                
            }
        }

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 2) {
            self.goto(screenID: "myMainNavigation", animated: true, data: nil, isModal: true, transition: self.transition)
        }
        
        
    }

}
