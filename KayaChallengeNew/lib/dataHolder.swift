//
//  dataHolder.swift
//  KayaChallengeNew
//
//  Created by Nok Danışmanlık on 4.01.2020.
//  Copyright © 2020 brokoly. All rights reserved.
//

import UIKit

class dataHolder: NSObject {
    let TAG:String = "dataHolder: "
    
    static let sharedInstance: dataHolder = {
        let instance = dataHolder()
        return instance
    }()
    
    override init() {
        super.init()
    }
    
//    MARK: - Variables
    
}
