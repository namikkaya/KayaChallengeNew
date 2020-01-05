//
//  Models.swift
//  KayaChallengeNew
//
//  Created by Nok Danışmanlık on 4.01.2020.
//  Copyright © 2020 brokoly. All rights reserved.
//

import Foundation

// genel bilgi
struct venues : Decodable{
    var id:String?
    var name:String?
    var location:location?
    var detail:detailModel?
    
    /**
     Usage: Mekan genel bilgisini tutar
     - Parameter value:  Value Açıklama
     */
    init(id:String?, name:String?, location:location?, detail:detailModel?) {
        self.id = id
        self.name = name
        self.location = location
        self.detail = detail
    }
}

// genel bilginin parçası olarak
struct location : Decodable {
    var lat:Double?
    var lng:Double?
    var city:String?
    
    /**
     Usage: Mekan adres ve lokasyon bilgileri
     - Parameter lat: Enlem
     - Parameter lng: Boylam
     - Parameter city: Yer
     */
    init(lat:Double?, lng:Double?, city:String?) {
        self.lat = lat
        self.lng = lng
        self.city = city
    }
}

// genel bilginin parçası olarak
struct detailModel :Decodable{
    var rating:Double?
    var ratingColor:String?
    
    /**
    Usage: Mekan adres ve lokasyon bilgileri
    - Parameter photoPath: Mekan fotosu
    - Parameter rating: Mekan puanı
    - Parameter ratingColor: mekan puan rengi
    */
    init(rating:Double?, ratingColor:String?) {
        self.rating = rating
        self.ratingColor = ratingColor
    }
}

// fotoğraf galerisi için
struct photoItemModel :Decodable {
    var id:String?
    var prefix:String?
    var suffix:String?
    var width:Int?
    var height:Int?
    var user:photoItemUserInfoModel?
    
    /**
    Usage: Fotoğraf bilgisi
    - Parameter id: id
    - Parameter prefix: resim başlangıç path
    - Parameter suffix: resim bitiş path
    - Parameter width: en
    - Parameter height: boy
    - Parameter user: [photoItemUserInfoModel] ekleyen kullanıcı bilgisi
    */
    init(id:String?, prefix:String?, suffix:String?, width:Int?, height:Int?, user: photoItemUserInfoModel) {
        self.id = id
        self.prefix = prefix
        self.suffix = suffix
        self.width = width
        self.height = height
        self.user = user
    }
    
}

// fotoğraf kullanıcı bilgisi
struct photoItemUserInfoModel :Decodable {
    var id:String?
    var firstName:String?
    var photo:userPhotoModel?
    
    /**
    Usage: Kullanıcı fotoğraf bilgisi
    - Parameter id: id
    - Parameter firstName: Kullanıcı ismi
    - Parameter photo: [userPhotoModel] Kullanıcı fotosu
    */
    init(id:String?, firstName:String?, photo:userPhotoModel?) {
        self.id = id
        self.firstName = firstName
        self.photo = photo
    }
}

// kulanıcının fotoğraf bilgisi
struct userPhotoModel :Decodable {
    var prefix:String?
    var suffix:String?
    /**
    Usage: kullanıcı fotoğrafı
    - Parameter id: id
    - Parameter prefix: Kullanıcı resim başlangıç path
    - Parameter suffix: Kullanıcı resim bitiş path
    */
    init(prefix:String?, suffix:String?) {
        self.prefix = prefix
        self.suffix = suffix
    }
}
