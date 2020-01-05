//
//  preloderTransition.swift
//  KayaChallengeNew
//
//  Created by Nok Danışmanlık on 4.01.2020.
//  Copyright © 2020 brokoly. All rights reserved.
//

import UIKit

class preloderTransition: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    private var presenting:Bool = true
    
    func mask(viewToMask: UIView, maskRect: CGRect) -> CAShapeLayer {
        let maskLayer = CAShapeLayer()
        
        let cirPath = UIBezierPath(arcCenter: .zero, radius: (maskRect.width)/2, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        maskLayer.path = cirPath.cgPath
        maskLayer.lineCap = CAShapeLayerLineCap.round
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.strokeColor = UIColor.black.cgColor
        maskLayer.position = viewToMask.center
        //viewToMask.layer.mask = maskLayer;
        return maskLayer
    }
    
    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if(presenting){
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
            let container = transitionContext.containerView
            let duration = self.transitionDuration(using: transitionContext)
            
            container.addSubview(toView)
            
            let maskLayer = mask(viewToMask: toView, maskRect: CGRect(x: toView.center.x-45, y: toView.center.y-45, width: 90, height: 90))
            
            toView.layer.mask = maskLayer
            
            var radiusScale:CGFloat = 1
            if toView.frame.size.width >= toView.frame.size.height {
                radiusScale = (toView.frame.size.width/90)*2
            }else{
                radiusScale = (toView.frame.size.height/90)*2
            }
            
            let scaleAnimate:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimate.fromValue = 1
            scaleAnimate.toValue = radiusScale
            scaleAnimate.duration = duration*1.6
            scaleAnimate.fillMode = CAMediaTimingFillMode.forwards;
            scaleAnimate.isRemovedOnCompletion = false
            scaleAnimate.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            maskLayer.add(scaleAnimate, forKey: "scaleSmallAnimation")
            
            //transitionContext.completeTransition(true)
            
            let openAnim = CGAffineTransform(scaleX: 1, y: 1)
            
            let startAnim = CGAffineTransform(scaleX: 0.6, y: 0.6)
            UIView.animate(withDuration: 0) {
                toView.transform = startAnim
                toView.alpha = 0.0
            }
            
            UIView.animate(withDuration: duration, animations: { () -> Void in
                toView.transform = openAnim
                toView.alpha = 1
            }) { (finished) -> Void in
                transitionContext.completeTransition(true)
            }
            
        }else {
            let fromView = transitionContext.view(forKey:UITransitionContextViewKey.from)!
            let container = transitionContext.containerView
            container.addSubview(fromView)
            
            let closeAnim = CGAffineTransform(scaleX: 2, y: 2)
            
            let duration = self.transitionDuration(using: transitionContext)
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
