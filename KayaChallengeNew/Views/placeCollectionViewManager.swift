//
//  placeCollectionViewManager.swift
//  KayaChallengeNew
//
//  Created by Nok Danışmanlık on 4.01.2020.
//  Copyright © 2020 brokoly. All rights reserved.
//

import UIKit


protocol placeCollectionViewManagerDelegate:class {
    /**
     Usage: CollectionView seçilen cell ile ilgili data yı ve numarayı döndürür
     - Parameter row:  id
     - Parameter data:  placeModel data
     */
    func placeCollectionViewManagerDidSelected(row:Int, data:venues?)
}

class placeCollectionViewManager: NSObject,
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource,
UICollectionViewDelegate {
    
    private let TAG:String = "placeCollectionViewManager:"
//    MARK: - Variable
    var data:[venues?]? = []
    weak var context:AnyObject?
    weak var delegate:placeCollectionViewManagerDelegate?
    
//    MARK: - Objects
    weak var collectionView:UICollectionView?
    
//    MARK: - Variable
    var cellWidth:CGFloat = 0
    var cellHeight:CGFloat = 0
    
    
    override init() {
        super.init()
    }
    
    convenience init(collectionView:UICollectionView, context:placeListViewController, collectionViewData:[venues?]?) {
        self.init()
        
        self.context = context
        self.delegate = context
        self.data = collectionViewData
        self.collectionView = collectionView
        
        config()
    }
    
    private func config() {
        collectionView!.delegate = self
        collectionView!.dataSource = self
        layoutCells()
        let nib = UINib(nibName: "placeCell", bundle: nil)
        self.collectionView!.register(nib, forCellWithReuseIdentifier: "placeCell")
    }
    
    private func layoutCells() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        
        layout.itemSize = calSize()!
        self.collectionView!.collectionViewLayout = layout
        if #available(iOS 11.0, *){
            layout.sectionInsetReference = .fromSafeArea
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = self.data {
            return data.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeCell", for: indexPath) as! placeCell
        let row = indexPath.row
        if let data = self.data {
            if let item = data[row] {
                cell.setup(data: item)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calSize()!
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeCell", for: indexPath) as? placeCell{
            let row = indexPath.row
            if let data = self.data {
                if let item = data[row] {
                    cell.setup(data: item)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        let selectedData = data![row]
        delegate?.placeCollectionViewManagerDidSelected(row: row, data: selectedData)
    }
}
