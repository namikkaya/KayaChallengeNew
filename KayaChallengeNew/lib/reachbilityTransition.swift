//
//  reachbilityTransition.swift
//  KayaChallengeNew
//
//  Created by Nok Danışmanlık on 4.01.2020.
//  Copyright © 2020 brokoly. All rights reserved.
//

import UIKit

class reachbilityTransition: NSObject,
    UIViewControllerAnimatedTransitioning,
UIViewControllerTransitioningDelegate {
    
    private var presenting:Bool = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if(presenting){
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
            let container = transitionContext.containerView
            
            //let duration = self.transitionDuration(using: transitionContext)
            let duration:TimeInterval = 0.3
            
            container.addSubview(toView)
            
            
            UIView.animate(withDuration: 0) {
                toView.alpha = 0.0
            }
            
            UIView.animate(withDuration: duration, animations: { () -> Void in
                toView.alpha = 1
            }) { (finished) -> Void in
                DispatchQueue.main.async {
                    transitionContext.completeTransition(true)
                }
            }
            
        }else {
            
            let fromView = transitionContext.view(forKey:UITransitionContextViewKey.from)!
            let container = transitionContext.containerView
            container.addSubview(fromView)
            
            let closeAnim = CGAffineTransform(scaleX: 2, y: 2)
            
            let duration:TimeInterval = 0.2
            
            UIView.animate(withDuration: duration, animations: { () -> Void in
                fromView.transform = closeAnim
                fromView.alpha = 0.0
            }) { (finished) -> Void in
                transitionContext.completeTransition(true)
            }
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    

}
