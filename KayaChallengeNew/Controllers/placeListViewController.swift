//
//  placeListViewController.swift
//  KayaChallengeNew
//
//  Created by Nok Danışmanlık on 4.01.2020.
//  Copyright © 2020 brokoly. All rights reserved.
//

import UIKit

class placeListViewController: BaseViewController, placeCollectionViewManagerDelegate {
    
    private let TAG: String = "placeListViewController "
    
//    MARK: - Variables
    var venueList:[venues?]?
    
    
//    MARK: - Objects
    @IBOutlet var collectionView: UICollectionView!
    
    
//    MARK: - Class
    private var collectionMan:placeCollectionViewManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarConfig()
        collectionViewConfig()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isOpenPreloader = false
    }
    
    private func navigationBarConfig() {
        self.setNavigationBarTitle(titleText: "Mekanlar")
    }
    
//    MARK: - CollectionView & Delegate
    
    private func collectionViewConfig() {
        collectionMan = placeCollectionViewManager(collectionView: collectionView,
                                                   context: self,
                                                   collectionViewData: venueList)
    }
    
    // Delegate --
    /// collectionView selected item
    func placeCollectionViewManagerDidSelected(row: Int, data: venues?) {
        self.goto(screenID: "detailViewControllerID",
                  animated: true,
                  data: data as AnyObject?,
                  isModal: true,
                  transition: self.preloaderTranstionDelegate)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailViewControllerSegue") {
            if let destinationController = segue.destination as? placeListViewController {
                destinationController.transitioningDelegate = self.preloaderTranstionDelegate
                destinationController.modalPresentationStyle = .overFullScreen
            }
        }
    }
}
