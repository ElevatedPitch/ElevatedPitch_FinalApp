//
//  TodoList.swift
//  InternTest
//
//  Created by Rahul Sheth on 7/19/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class TodoList {
    class var sharedInstance : TodoList {
        
        struct Static {
            static let instance: TodoList = TodoList()
            
        }
        return Static.instance
    }
    
    fileprivate let items_key = "todoItems"
    func addItem( item: TodoItem) {
      
        let notification = UILocalNotification()
        notification.alertBody = item.UUID
        notification.alertBody?.append(" is free now")
        notification.alertAction = "open"
        notification.fireDate = item.deadline
        notification.userInfo = ["title": item.title, "UUID": item.UUID]
        UIApplication.shared.scheduleLocalNotification(notification)
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            content.title = "Student Alert"
            content.subtitle = "From Elevated Pitch"
            content.body = item.UUID
            content.body.append(" is free now")
            content.badge = 1
         
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (item.deadline?.timeIntervalSinceNow)!, repeats: false)
            let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        }
       
    }
    
    

