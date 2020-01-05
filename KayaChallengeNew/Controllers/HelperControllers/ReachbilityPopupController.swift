//
//  ReachbilityPopupController.swift
//  KayaChallengeNew
//
//  Created by Nok Danışmanlık on 4.01.2020.
//  Copyright © 2020 brokoly. All rights reserved.
//

import UIKit
import Reachability

/**
 Usage: İnternet bağlantısı kesildiğinde ekrana açılır. Bağlantı geldiğinde otomatik kapanır.
 */
class ReachbilityPopupController: UIViewController {
    private let TAG:String = "ReachbilityPopupController:"
//    MARK: - Class
    let reachability = try! Reachability()
    
//    MARK: - View
    @IBOutlet var popupView: UIView!
    
//    MARK: - Variable
    var isNoConnection = false
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        super.viewDidLoad()
        popupView.layer.cornerRadius = 8.0
        contentUIStartConfig()
    }
    
    private func setupReachability() {
        if isNoConnection {
            return
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged(note:)),
                                               name: .reachabilityChanged,
                                               object: reachability)

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentUIContinuous()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupReachability()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self,
                                                  name: .reachabilityChanged,
                                                  object: reachability)
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        if reachability.connection != .unavailable {
            self.back(animated: true, isModal: true)
        }
    }
    
    
    // -------------------------------
    // Sayfa açılış animasyonu - START
    
    private func contentUIStartConfig() {
        self.popupView.translatesAutoresizingMaskIntoConstraints = false
        UIView.animate(withDuration: 0.1) {
            self.popupView.alpha = 0.0
            self.popupView.transform = CGAffineTransform(translationX: 0, y: 20)
        }
    }
    
    private func contentUIContinuous() {
        UIView.animate(withDuration: 0.2, animations: {
            self.popupView.alpha = 1
            self.popupView.transform = CGAffineTransform(translationX: 0, y: -20)
        }) { (status) in
            //--
        }
    }
    
    private func exitViewController() {
        UIView.animate(withDuration: 0.2, animations: {
            self.popupView.alpha = 0.0
            self.popupView.transform = CGAffineTransform(translationX: 0, y: 20)
        }) { (status) in
            self.dismiss(animated: true, completion: {
                // --
            })
        }
    }
    
    // Sayfa açılış animasyonu - END
    // --------------------------
    
}
