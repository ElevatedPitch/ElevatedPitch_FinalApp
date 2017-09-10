//
//  Notification.swift
//  InternTest
//
//  Created by Rahul Sheth on 7/2/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import Foundation

class Notification: NSObject {
    
    var type: String?
    var message: String?
    var otherUID: String?
    var profileImageURL: String?
    var user: User?
    var read: String?
    var number: String?
    
    
    //Used for meeting notifications
    var timeString: String?
    var extraNote: String?
    

}
