//
//  mainViewController.swift
//  KayaChallengeNew
//
//  Created by Nok Danışmanlık on 4.01.2020.
//  Copyright © 2020 brokoly. All rights reserved.
//

import UIKit

class mainViewController: BaseViewController, cityInputDelegate {
    private let TAG: String = "mainViewController "
    
    private var searchData:[venues?]? = []
    
//    MARK: - Objects
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var cityInputView: cityInput!
    
//    MARK: - Variables
    internal var bottomConstraintHolder:CGFloat!
    internal var keyboardStatus:Bool = false
    internal var lastKeyboardHeight:CGFloat = 0
    
    
//    MARK: - Class
    private var dh:dataHolder?
    private var service:serviceManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dh = dataHolder.sharedInstance
        service = serviceManager.sharedInstance
        
        bottomConstraintHolder = bottomConstraint.constant
        cityInputView.delegate = self
        hideKeyboardWhenTappedAround()
        navigationBarConfig()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.observeKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.observeRemovekeyboardNotification()
    }
    
//    MARK: - Configuration
    private func navigationBarConfig() {
        self.setNavigationBarTitle(titleText: "Ana Sayfa")
    }
    
//    MARK: - cityInput View Delegate
    
    // cityInputView den tetiklenir
    func cityInputActionEvent(searchString: String?) {
        if let searchString = searchString {
            self.isOpenPreloader = true
            //self.performSegue(withIdentifier: "listPageSegueID", sender: self)
            searchCity(cityName: searchString)
        }
    }
    
//    MARK: - Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "listPageSegueID") {
            if let destinationController = segue.destination as? placeListViewController {
                destinationController.venueList = self.searchData
            }
        }
    }
    
//    MARK: - fourSquare
    
    /**
     Usage:  Şehir trend mekanları
     - Parameter cityName:  Şehir ismi
     - Returns: No return value
     */
    private func searchCity(cityName:String) {
        service?.searchPlace(cityName: cityName, onResult: { (data:[venues?]?) in
            if let data = data{
                self.searchData = data
            }
            self.performSegue(withIdentifier: "listPageSegueID", sender: self)
        }, onFail: { (errorStr:String?) in
            self.isOpenPreloader = false
            if let errorStr = errorStr {
                DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 0.5) {
                    self.informationAlert(title: "Hata!", message: errorStr, positiveButtonTitle: "Tamam", negativeButtonTitle: nil) { (status:Bool?) in
                        // button Click
                    }
                }
            }
        })
    }
    
    
    
}
