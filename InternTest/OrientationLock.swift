//
//  OrientationLock.swift
//  InternTest
//
//  Created by Rahul Sheth on 6/28/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import Foundation
import UIKit
//Lock to portrait mode 
struct AppUtility {
    
    
    static func lockOrientation(orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
        
        
    }
    
    static func lockOrientation(orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation: UIInterfaceOrientation) {
        self.lockOrientation(orientation: orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
}
