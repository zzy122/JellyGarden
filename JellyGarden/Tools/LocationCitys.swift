//
//  LocationCitys.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import CoreLocation

class LocationCitys: NSObject {
    typealias locationMessage = (String?,CLLocation?) -> Void
    
    
    var locationBlock:locationMessage?
    
    lazy var locationM: CLLocationManager = {//info.plist add :Privacy - Location Always Usage Description
        let locationM = CLLocationManager()
        guard CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied else{
            AlertViewCoustom().showalertView(style: .alert, title: alertTitle, message: "位置获取失败,请前往设置打开应用位置权限", cancelBtnTitle: alertConfirm, touchIndex: { (index) in
                
            }, otherButtonTitles: nil)
            return locationM
        }
        if #available(iOS 8.0, *) {
            locationM.requestWhenInUseAuthorization()
        }
        return locationM
    }()
    init(backMessage:@escaping locationMessage) {
        super.init()
        self.locationBlock = backMessage
        self.locationM.delegate = self
    }
    func startLocation() {
        self.locationM.startUpdatingLocation()
    }
    lazy var geoCoder: CLGeocoder = {
        return CLGeocoder()
    }()

}

extension LocationCitys:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {return}
        print(newLocation)//<+31.26514482,+121.61259089> +/- 50.00m (speed 0.00 mps / course -1.00) @ 2016/11/14 中国标准时间 14:49:51
        if newLocation.horizontalAccuracy < 0 { return }
        self.geoCoder.reverseGeocodeLocation(newLocation) { (pls: [CLPlacemark]?, error: Error?) in
            if error == nil {
                guard let pl = pls?.first else {return}
                
                self.locationBlock?(pl.locality,locations.first)
                /*
                 open var name: String? { get } // eg. Apple Inc.
                 open var thoroughfare: String? { get } // street name, eg. Infinite Loop
                 open var subThoroughfare: String? { get } // eg. 1
                 open var locality: String? { get } // city, eg. Cupertino
                 open var subLocality: String? { get } // neighborhood, common name, eg. Mission District
                 open var administrativeArea: String? { get } // state, eg. CA
                 open var subAdministrativeArea: String? { get } // county, eg. Santa Clara
                 open var postalCode: String? { get } // zip code, eg. 95014
                 open var isoCountryCode: String? { get } // eg. US
                 open var country: String? { get } // eg. United States
                 open var inlandWater: String? { get } // eg. Lake Tahoe
                 open var ocean: String? { get } // eg. Pacific Ocean
                 open var areasOfInterest: [String]? { get } // eg. Golden Gate Park
                 */
            }
        }
        manager.stopUpdatingLocation()
    }
}
