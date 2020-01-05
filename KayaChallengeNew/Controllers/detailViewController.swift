//
//  detailViewController.swift
//  KayaChallengeNew
//
//  Created by Nok Danışmanlık on 5.01.2020.
//  Copyright © 2020 brokoly. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage

class detailViewController: BaseViewController {
    
//    MARK: - Object
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userFirstNameLabel: UILabel!
    
//    MARK: - Variables
    let annotation = MKPointAnnotation()
    var venueData:venues!
    
//    MARK: - class
    var service: serviceManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        service = serviceManager.sharedInstance
        
        if let myData = self.data as? venues {
            venueData = myData
        }
        
        contentView.isUserInteractionEnabled = true
        
        if let location = venueData.location {
            if let lat = location.lat, let lng = location.lng {
                let myVenueLocation = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                annotation.coordinate = myVenueLocation
                if let venueName = venueData.name{
                    annotation.title = venueName
                }
                let viewRegion = MKCoordinateRegion(center: myVenueLocation, latitudinalMeters: 500, longitudinalMeters: 500)
                self.mapView.setRegion(viewRegion, animated: true)
                mapView.addAnnotation(annotation)
            }
        }
        
    }
    
    
    private func getPhotoData() {
        if let id = venueData.id {
            service?.placePhotos(id: id, onSuccess: { (_id:String?, photos: [photoItemModel?]?) in
                self.isOpenPreloader = false
                if let photos = photos {
                    if let user = photos[0]?.user {
                        self.userFirstNameLabel.text = user.firstName
                        let userImagePhotoPath = "\(user.photo!.prefix!)80x80\(user.photo!.suffix!)"
                        let url:URL = URL(string: userImagePhotoPath)!
                        self.userImageView.sd_setImage(with: url, completed: nil)
                        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2
                        self.userImageView.layer.masksToBounds = true
                    }
                    
                    if let prefix = photos[0]?.prefix,
                        let suffix = photos[0]?.suffix {
                        
                        let imagePath = "\(prefix)500x500\(suffix)"
                        let url:URL = URL(string: imagePath)!
                        self.imageView.sd_setImage(with: url) { (img, error, cache, url) in
                            self.imageView.contentMode = .scaleAspectFill
                        }
                        //imageView.sd_setImage(with: URL(string: "http://www.domain.com/path/to/image.jpg"), placeholderImage: UIImage(named: "placeholder.png"))
                    }
                    
                }
                
            }, onFail: { (_id:String?, error:String?) in
                self.userFirstNameLabel.text = "Api limiti doldu."
                self.isOpenPreloader = false
                DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 0.5) {
                    self.informationAlert(title: "Hata!", message: error!, positiveButtonTitle: "Tamam", negativeButtonTitle: nil) { (status) in
                        //
                    }
                }
                
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isOpenPreloader = true
        getPhotoData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        print("willdisappear")
        
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view == self.view {
            exitViewController()
        }
    }
    
    private func exitViewController() {
        self.back(animated: true, isModal: true)
    }
}
