//
//  BaseViewController.swift
//  KayaChallengeNew
//
//  Created by Nok Danışmanlık on 4.01.2020.
//  Copyright © 2020 brokoly. All rights reserved.
//

import UIKit
import Reachability

class BaseViewController: UIViewController {
    private let TAG:String = "BaseViewController: "

    var reachability = try! Reachability()
    
    // Sayfa efek
    var reachabilityTranstionDelegate = reachbilityTransition()
    var preloaderTranstionDelegate = preloderTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupReachability()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged(note:)),
                                               name: .reachabilityChanged,
                                               object: reachability)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: .reachabilityChanged,
                                                  object: reachability)
    }
    
    func setupReachability() {
        do{
            try reachability.startNotifier()
        } catch {
            print("\(self.TAG): could not start notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        if reachability.connection != .unavailable {
            print("\(self.TAG): reachabilityChanged unavailable")
        } else {
            DispatchQueue.main.async {
                self.goto(screenID: "ReachbilityPopupControllerID",
                          animated: true,
                          data: nil,
                          isModal: true,
                          transition: self.reachabilityTranstionDelegate)
            }
        }
    }
    
    /// preloader açılmak isteniyor ise true. kapatılacak ise false
    var isOpenPreloader:Bool = true {
        didSet {
            if (isOpenPreloader) {
                DispatchQueue.main.async {
                    self.goto(screenID: "preloaderPopupControllerID",
                              animated: true,
                              color: [UIColor.blue, UIColor.green, UIColor.red],
                              message: "Lütfen bekleyin",
                              transition: self.preloaderTranstionDelegate)
                }
            }else {
                self.back(animated: true, isModal: true)
            }
        }
    }
    
    

}
