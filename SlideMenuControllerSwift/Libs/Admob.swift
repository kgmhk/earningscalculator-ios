//
//  Admob.swift
//  SlideMenuControllerSwift
//
//  Created by Kwak, GiHyun on 02/08/2018.
//

import Foundation
import GoogleMobileAds

class Admob {
    static func adLoad() -> GADRequest {
        let request = GADRequest();
//                request.testDevices = [ kGADSimulatorID,                       // All simulators
//                    "2077ef9a63d2b398840261c8221a0c9b" ];  // Sample device ID
        
        return request;
    }
}

