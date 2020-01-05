//
//  serviceManager.swift
//  KayaChallengeNew
//
//  Created by Nok Danışmanlık on 4.01.2020.
//  Copyright © 2020 brokoly. All rights reserved.
//

import UIKit
import FoursquareAPIClient

class serviceManager: NSObject {
    let TAG:String = "serviceManager"
    private let clientId:String = "U3ZSGRRZPY3TPFVQXDOQ1JEEVGUOHFEYONSZCOXTAPWK1YQ3"
    private let clientSecret:String = "W0GMMI5RTIG0B0ZO4GVVK3ONG2PWHSBWMXMM2NIOO1N3YOCO"
    
//    MARK: - Class
    private var placeData:[venues?]?
    private var photosData:[photoItemModel?]?
    
//    MARK: - Variables
    var client:FoursquareAPIClient?
    private let PlaceDataLimit:Int = 10
    private let PlaceCategory = "coffee"
    
    private var counter:Int = 0
    
    
    override init() {
        super.init()
        print("\(self.TAG): serviceManager init")
        client = FoursquareAPIClient(clientId: clientId, clientSecret: clientSecret)
    }
    
    static let sharedInstance: serviceManager = {
        let instance = serviceManager()
        return instance
    }()
    
    
    /**
     Usage:  Arama yapar
     - Parameter cityName:  Şehir adı
     */
    func searchPlace(cityName:String,
                     onResult dataResult: @escaping ([venues?]?) -> (),
                     onFail failInfo: @escaping (String?)->()) {
        
        if placeData != nil {
            for i in 0..<placeData!.count {
                placeData![i] = nil
            }
            placeData?.removeAll()
            placeData = nil
        }
        
        let dLimit:String = String(PlaceDataLimit)
        
        let parameter: [String: String] = [
            "near" : cityName,
            "query" : PlaceCategory,
            "limit" : dLimit
        ];
        
        getData(serviceName: "venues/search", parameter: parameter, onSuccess: { (data) in
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let response = (json as AnyObject).value(forKey: "response") as? NSDictionary {
                    if let venuesArray = response.value(forKey: "venues") as? NSArray {
                        if venuesArray.count > 0 {
                            let venuesData = try JSONSerialization.data(withJSONObject: venuesArray , options: [])
                            self.placeData = try JSONDecoder().decode([venues].self, from: venuesData)
                            
                            if self.placeData != nil {
                                //dataResult(self.placeData)
                                
                                self.counter = 0
                                for j in 0..<self.placeData!.count {
                                    if let item = self.placeData![j] {
                                        self.searchPlaceDetail(id: item.id, onSuccess: { (id:String?, dModel:detailModel?) in
                                            for s in 0..<self.placeData!.count {
                                                if let mItem = self.placeData![s]{
                                                    if mItem.id == id {
                                                        self.placeData![s]?.detail = dModel
                                                    }
                                                }
                                            }
                                            self.counter += 1
                                            if self.placeData!.count <= self.counter {
                                                dataResult(self.placeData)
                                            }
                                        }) { (id:String?, errorStr:String?) in
                                            self.counter += 1
                                            if self.placeData!.count <= self.counter {
                                                dataResult(self.placeData)
                                            }
                                            print("\(self.TAG): DETAil::: \(errorStr ?? "")")
                                        }
                                    }
                                }
                                
                            }
                            
                        }else {
                           failInfo("Arama sonucu boş döndü.")
                        }
                    }
                }
                
            } catch let err {
                print("err: \(err)")
            }
        }) { (fail:String?) in
            failInfo(fail)
        }
    }
    
    /**
     Usage:  Mekan id sine göre detay (rating ve rating rengini getirir)
     - Parameter id:  mekan id si
     */
    func searchPlaceDetail(id:String?,
                           onSuccess dataRes: @escaping (String?,detailModel?) -> (),
                           onFail failInfo: @escaping (String?,String?)->()) {
        if let id = id {
            let parameter: [String: String] = [:]
            let searchString = "venues/\(id)"
            getData(serviceName: searchString, parameter: parameter, onSuccess: { (data) in
                do {
                    let json = try! JSONSerialization.jsonObject(with: data, options: [])
                    if let response = (json as AnyObject).value(forKey: "response") as? NSDictionary {
                        if let venue = response.value(forKey: "venue") as? NSDictionary {
                            let venueData = try JSONSerialization.data(withJSONObject: venue , options: [])
                            let detailData = try JSONDecoder().decode(detailModel.self, from: venueData)
                            dataRes(id,detailData)
                        }
                    }
                } catch let err {
                    print("err: searchPlace: \(err)")
                }
            }) { (data:String?) in
                failInfo(id,data)
            }
        }
    }
    
    func placePhotos(id:String?,
                     onSuccess dataRes: @escaping (String?,[photoItemModel?]?) -> (),
                     onFail failInfo: @escaping (String?,String?)->()) {
        if let id = id {
            if photosData != nil {
                for i in 0..<photosData!.count {
                    photosData![i] = nil
                }
                photosData?.removeAll()
                photosData = nil
            }
            
            let parameter: [String: String] = [
                "limit" : "1"
            ];
            let searchString = "venues/\(id)/photos"
            getData(serviceName: searchString, parameter: parameter, onSuccess: { (data) in
                do {
                    let json = try! JSONSerialization.jsonObject(with: data, options: [])
                    print("json photo: \(json)")
                    if let response = (json as AnyObject).value(forKey: "response") as? NSDictionary {
                        if let photos = response.value(forKey: "photos") as? NSDictionary {
                            if let items = photos.value(forKey: "items") as? NSArray {
                                let photoItemsData = try JSONSerialization.data(withJSONObject: items , options: [])
                                self.photosData = try JSONDecoder().decode([photoItemModel].self, from: photoItemsData)
                                dataRes(id, self.photosData)
                            }
                        }
                    }
                } catch let err {
                    print("err: searchPlace: \(err)")
                }
            }) { (data:String?) in
                print("HATA DÖNDÜ + \(data!)")
                
                //failInfo(id,data)
                
                /*
                 limitlere takıldığında detay için aşağıda ki sample data döndürülür.
                 */
                let fakeDataString:String = "{ \"meta\": { \"code\": 200, \"requestId\": \"5997070d6a60717704801060\" }, \"response\": {\"photos\": { \"count\": 1, \"items\": [ { \"id\": \"51e4151c498e60b5d17bc721\",\"createdAt\": 1373902108,\"source\": { \"name\": \"Instagram\",\"url\": \"http://instagram.com\" }, \"prefix\": \"https://igx.4sqi.net/img/general/\", \"suffix\": \"/1022386_wEd7VXnWzp5lajvRLtAPunoiufDSIq8PMEtEuIH2Tzg.jpg\", \"width\": 612, \"height\": 612, \"user\": {\"id\": \"123456\", \"firstName\": \"John- limit dolduğu için fake data\", \"lastName\": \"D\", \"photo\": { \"prefix\": \"https://igx.4sqi.net/img/user/\", \"suffix\": \"/YXNQ5O4TLYSNHMKY.jpg\" } }, \"checkin\": { \"id\": \"51e4151b498ea66547febfaf\", \"createdAt\": 1373902107, \"type\": \"checkin\", \"timeZoneOffset\": -240 }, \"visibility\": \"public\" } ], \"dupesRemoved\": 0 } } }"
                
                let dataR = fakeDataString.data(using: .utf8)!
                do {
                    let json = try! JSONSerialization.jsonObject(with: dataR, options: [])
                    if let response = (json as AnyObject).value(forKey: "response") as? NSDictionary {
                        if let photos = response.value(forKey: "photos") as? NSDictionary {
                            if let items = photos.value(forKey: "items") as? NSArray {
                                let photoItemsData = try JSONSerialization.data(withJSONObject: items , options: [])
                                self.photosData = try JSONDecoder().decode([photoItemModel].self, from: photoItemsData)
                                dataRes(id, self.photosData)
                            }
                        }
                    }
                } catch let err {
                    print("err: searchPlace: \(err)")
                }
                
            }
        }
        
    }
    
    /// service verilerini döndürür.
    private func getData(serviceName:String,
                 parameter:[String: String],
                 onSuccess dataResult: @escaping ((Data)) -> (),
                 onFail failInfo: @escaping (String?)->()) {
        
        client?.request(path: serviceName, parameter: parameter, completion: { (result) in
            switch result {
            case let .success(data):
                dataResult(data)
            case let .failure(error):
                switch error {
                case let .connectionError(connectionError):
                    failInfo(connectionError.localizedDescription)
                    break
                case let .responseParseError(responseParseError):
                    failInfo(responseParseError.localizedDescription)
                    break
                case let .apiError(apiError):
                    failInfo(apiError.errorDetail)
                    break
                }
            }
        })
    }
}
