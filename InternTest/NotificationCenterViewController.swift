//
//  NotificationCenter.swift
//  InternTest
//
//  Created by Rahul Sheth on 7/2/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import UIKit
import Firebase


//All of your notifications and stuff
class NotificationCenterViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    

   

    //INITIALIZATION OF VARIABLES 
    
    
    
    var tableView = UITableView()
    let uid = FIRAuth.auth()?.currentUser?.uid
    var notificationList = [Notification]()
    let ref = FIRDatabase.database().reference().child("users")
    var cellID = "CellID"
    let picker = UIDatePicker()
    var dateAlert = UIAlertController()
    //------------------------------------------------------------------------
    
    //HELPER FUNCTIONS AND VIEW DID LOAD
    
    func setUpTopNavBar() {
        
        let titleLabel = UILabel()
        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Notifications"
        titleLabel.font = UIFont(name: "Didot", size: 24)
        titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        titleLabel.textColor = UIColor.white
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -10).isActive = true
        
    }
    override func viewDidLoad() {
        fetchNotifications()
       
       
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60).isActive = true
        tableView.separatorStyle = .none
        
        createMastHead()
        
        
        
    }
    
    
    
    
    func setUpBottomNavBar() {
        let width = self.view.bounds.width
        
        let LogoutButton = UIButton()
        let logoutText = UILabel()
        let logoutImageView = UIImageView()
        
        
        let ProfileButton = UIButton()
        let profileText = UILabel()
        let profileImageView = UIImageView()
        
        let FeedButton = UIButton()
        let feedText = UILabel()
        let feedImageView = UIImageView()
        
        let notificationsButton = UIButton()
        let notificationText = UILabel()
        let notificationImageView = UIImageView()
        
        
        self.view.addSubview(LogoutButton)
        LogoutButton.translatesAutoresizingMaskIntoConstraints = false
        LogoutButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        LogoutButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        LogoutButton.widthAnchor.constraint(equalToConstant: width / 4).isActive = true
        LogoutButton.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        LogoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        LogoutButton.addSubview(logoutText)
        logoutText.translatesAutoresizingMaskIntoConstraints = false
        logoutText.text = "Logout"
        logoutText.font = UIFont(name: "Didot", size: 12)
        logoutText.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        logoutText.centerXAnchor.constraint(equalTo: LogoutButton.centerXAnchor).isActive = true
        logoutText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        LogoutButton.addSubview(logoutImageView)
        logoutImageView.translatesAutoresizingMaskIntoConstraints = false
        logoutImageView.image = UIImage(named: "images")
        logoutImageView.translatesAutoresizingMaskIntoConstraints = false
        logoutImageView.bottomAnchor.constraint(equalTo: logoutText.topAnchor, constant: 5).isActive = true
        logoutImageView.centerXAnchor.constraint(equalTo: LogoutButton.centerXAnchor).isActive = true
        logoutImageView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10).isActive = true
        
        logoutImageView.transform = logoutImageView.transform.rotated(by: CGFloat(M_PI))
        
        
        
        
        self.view.addSubview(ProfileButton)
        ProfileButton.translatesAutoresizingMaskIntoConstraints = false
        ProfileButton.leftAnchor.constraint(equalTo: LogoutButton.rightAnchor).isActive = true
        ProfileButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        ProfileButton.widthAnchor.constraint(equalToConstant: width / 4).isActive = true
        ProfileButton.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        ProfileButton.addTarget(self, action: #selector(handleMoveToProfile), for: .touchUpInside)
        
        
        ProfileButton.addSubview(profileText)
        profileText.translatesAutoresizingMaskIntoConstraints = false
        profileText.text = "Profile"
        profileText.font = UIFont(name: "Didot", size: 12)
        profileText.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        profileText.centerXAnchor.constraint(equalTo: ProfileButton.centerXAnchor).isActive = true
        profileText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        ProfileButton.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.image = UIImage(named: "ProfileImage")
        profileImageView.bottomAnchor.constraint(equalTo: profileText.topAnchor, constant: 5).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: ProfileButton.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: width / 4 - 40).isActive = true
        
        self.view.addSubview(FeedButton)
        FeedButton.translatesAutoresizingMaskIntoConstraints = false
        FeedButton.leftAnchor.constraint(equalTo: ProfileButton.rightAnchor).isActive = true
        FeedButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        FeedButton.widthAnchor.constraint(equalToConstant: width / 4).isActive = true
        FeedButton.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        FeedButton.addTarget(self, action: #selector(handleMoveToFeed), for: .touchUpInside)
        
        
        FeedButton.addSubview(feedText)
        feedText.translatesAutoresizingMaskIntoConstraints = false
        feedText.text = "Feed"
        feedText.font = UIFont(name: "Didot", size: 12)
        feedText.bottomAnchor.constraint(equalTo: profileText.bottomAnchor).isActive = true
        feedText.centerXAnchor.constraint(equalTo: FeedButton.centerXAnchor).isActive = true
        feedText.heightAnchor.constraint(equalTo: profileText.heightAnchor).isActive = true
        
        FeedButton.addSubview(feedImageView)
        feedImageView.image = UIImage(named: "FeedButton")
        feedImageView.translatesAutoresizingMaskIntoConstraints = false
        feedImageView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        feedImageView.centerXAnchor.constraint(equalTo: FeedButton.centerXAnchor).isActive = true
        feedImageView.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        feedImageView.widthAnchor.constraint(equalToConstant: width / 4 - 50).isActive = true
        
        self.view.addSubview(notificationsButton)
        notificationsButton.translatesAutoresizingMaskIntoConstraints = false
        notificationsButton.leftAnchor.constraint(equalTo: FeedButton.rightAnchor).isActive = true
        notificationsButton.bottomAnchor.constraint(equalTo: FeedButton.bottomAnchor).isActive = true
        notificationsButton.widthAnchor.constraint(equalToConstant: width / 4).isActive = true
        notificationsButton.topAnchor.constraint(equalTo: FeedButton.topAnchor).isActive = true
        notificationsButton.addTarget(self, action: #selector(moveToNotification), for: .touchUpInside)
        
        notificationsButton.addSubview(notificationText)
        notificationText.translatesAutoresizingMaskIntoConstraints = false
        notificationText.text = "Notifications"
        notificationText.font = UIFont(name: "Didot", size: 12)
        notificationText.bottomAnchor.constraint(equalTo: profileText.bottomAnchor).isActive = true
        notificationText.centerXAnchor.constraint(equalTo: notificationsButton.centerXAnchor).isActive = true
        notificationText.heightAnchor.constraint(equalTo: profileText.heightAnchor).isActive = true
        
        notificationsButton.addSubview(notificationImageView)
        notificationImageView.image = UIImage(named: "notificationIcon")
        notificationImageView.translatesAutoresizingMaskIntoConstraints = false
        notificationImageView.bottomAnchor.constraint(equalTo: feedImageView.bottomAnchor).isActive = true
        notificationImageView.centerXAnchor.constraint(equalTo: notificationsButton.centerXAnchor).isActive = true
        notificationImageView.topAnchor.constraint(equalTo: feedImageView.topAnchor).isActive = true
        notificationImageView.widthAnchor.constraint(equalTo: feedImageView.widthAnchor).isActive = true
        
        
        
        
        
        
    }
    
    
    func handleMoveToFeed() {
        let segueController = FeedController(nibName: nil, bundle: nil)
        present(segueController, animated: false, completion: nil)
    }
    func moveToNotification() {
        let segueController = NotificationCenterViewController()
        present(segueController, animated: false, completion: nil)
    }
    
    func handleMoveToProfile() {
        let segueController = ProfilePageViewController()
        present(segueController, animated: false, completion: nil)
    }
    
    
    func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let segueController = LandingPageViewController()
        present(segueController, animated: true, completion: nil)
        
    }
    
    func handleDateChange(sender: UIDatePicker ) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        let timeString1 = formatter.string(from: picker.date)
        
        
        self.dateAlert.textFields?[0].text = timeString1
    }
    


    
    //Set up the function targets now
    
    
    //If it's a message, call this 
    func handleMessageType(sender: SendButton)  {
        changeRead(notification: sender.notification!)
        sender.user.previousController = NotificationCenterViewController()
        let segueController = ChatController(user: sender.user)

        present(segueController, animated: true, completion: nil)
    }
    
    //If it's a friend notification call this.
    func handleFriendType(sender: SendButton) {
        changeRead(notification: sender.notification!)
        if (sender.notification?.user?.occupation == "Student") {
         let segueController = StudentViewController(user: sender.user)
            present(segueController, animated: true, completion: nil)

        } else {
            let segueController = EmployerViewController(nibName: nil, bundle: nil)
            segueController.user = sender.user
            present(segueController, animated: true, completion: nil)

        }

        
    }
    
    
    func textFieldContinueEditing(textView: UITextField) {
        picker.translatesAutoresizingMaskIntoConstraints = false
        textView.inputView = picker
    }
    
    
    
    
    func returnDayFromWeekDayInt(weekDay: Int) -> String {
        
        switch  weekDay {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        default:
            return "Saturday"
        }
    }
    
    
   
    
    func handleAcceptedType(sender: SendButton) {
        
        changeRead(notification: sender.notification!)
        let notification = sender.notification
        
        var titleString = notification?.user?.name
        titleString?.append(" set a reminder for: ")
        titleString?.append((notification?.timeString)!)
 
        
        let messageString = "Would you like to set the same? (Note: Push no to set your own reminder or set no reminder)"
        
        let alert = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (error) in
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            print(notification?.timeString, "This is your timeString again")
            let date = formatter.date(from: (notification?.timeString)!)
            let todoItem = TodoItem()
            
            todoItem.title = "Reminder: Meeting with "
            todoItem.title.append((notification?.user?.name)!)
            todoItem.UUID = "Elevated Pitch"
            todoItem.deadline = date
            TodoList.sharedInstance.addItem(item: todoItem)
            //Have to set up dictionary["Day"], dictionary["Start Time"] and dictionary["End Time"]
            
            
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier(rawValue: NSGregorianCalendar))
            let unitFlags: NSCalendar.Unit = [.hour, .minute, .weekday]
            let myComponents = myCalendar?.components(unitFlags, from: date!)
            let hour = myComponents?.hour
            let minute = myComponents?.minute
            let day = self.returnDayFromWeekDayInt(weekDay:  (myComponents?.weekday!)!)
            let updateHour = NSNumber(value: hour!)
            let updateMinute = NSNumber(value: minute!)
            formatter.timeStyle = .none
            let dateString = NSString(string: formatter.string(from: date!))
            let name = NSString(string: (notification?.user?.name)!)
            let value = ["Day": day as NSString, "StartHour": updateHour, "StartMinute": updateMinute, "DateString": dateString, "Name": name]
            
            let ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("Reminders").child(day).child((notification?.user?.uid)!)
            
            ref.updateChildValues(value)
            
            

            
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (error) in
            self.dateAlert = UIAlertController(title: "Set a Reminder", message: "", preferredStyle: .alert)
            self.dateAlert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Enter Date..."
                self.picker.translatesAutoresizingMaskIntoConstraints = false
                textField.inputView = self.picker
                textField.delegate = self
                
            })
            self.picker.addTarget(self, action: #selector(self.handleDateChange), for: .valueChanged)
            self.dateAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler:  { (error) in
                
                
                let date = self.picker.date
                let todoItem = TodoItem()
                
                todoItem.title = "Reminder: Meeting with "
                todoItem.title.append((notification?.user?.name)!)
                todoItem.UUID = "Elevated Pitch"
                todoItem.deadline = date
                TodoList.sharedInstance.addItem(item: todoItem)
                
               
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier(rawValue: NSGregorianCalendar))
                let unitFlags: NSCalendar.Unit = [.hour, .minute, .weekday]
                let myComponents = myCalendar?.components(unitFlags, from: date)
                let hour = myComponents?.hour
                let minute = myComponents?.minute
                let day = self.returnDayFromWeekDayInt(weekDay:  (myComponents?.weekday!)!)
                let updateHour = NSNumber(value: hour!)
                let updateMinute = NSNumber(value: minute!)
                formatter.timeStyle = .none
                let dateString = NSString(string: formatter.string(from: date))
                let name = NSString(string: (notification?.user?.name)!)

                let value = ["Day": day as NSString, "StartHour": updateHour, "StartMinute": updateMinute, "DateString": dateString, "Name": name]
                 let ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("Reminders").child(day).child((notification?.user?.uid)!)
                ref.updateChildValues(value)
                
                
            }))
            self.dateAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            self.present(self.dateAlert, animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    
    }
    
   
    func handleMeetingType(sender: SendButton) {
       
        changeRead(notification: sender.notification!)
        let notification = sender.notification
        var titleString = notification?.user?.name
        titleString?.append(" : ")
        titleString?.append((notification?.timeString)!)
        
        var messageString = "Note: "
        messageString.append((notification?.extraNote)!)
        let alert = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (error) in
            self.dateAlert = UIAlertController(title: "Set a Reminder", message: "", preferredStyle: .alert)
            self.dateAlert.addTextField(configurationHandler: { (textField) in
             textField.placeholder = "Enter Date..."
                self.picker.translatesAutoresizingMaskIntoConstraints = false
                textField.inputView = self.picker
                textField.delegate = self
                
            })
            self.picker.addTarget(self, action: #selector(self.handleDateChange), for: .valueChanged)
            self.dateAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler:  { (error) in
                
                var messageString2 = globalCurrentName
                messageString2.append(" accepted your meeting invite")
                let messageString = NSString(string: messageString2)
                let sendingID = NSString(string: (FIRAuth.auth()?.currentUser?.uid)!)
                let typeString = "Accepted" as NSString
                let imageURLString = NSString(string: globalProfilePictureImageURL)
                
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .short
                
                let timeString1 = formatter.string(from: self.picker.date)
                
                let todoItem = TodoItem()
                
                todoItem.title = "Reminder: Meeting with "
                todoItem.title.append((notification?.user?.name)!)
                todoItem.UUID = "Elevated Pitch"
                todoItem.deadline = self.picker.date
                TodoList.sharedInstance.addItem(item: todoItem)
               
                let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier(rawValue: NSGregorianCalendar))
                let unitFlags: NSCalendar.Unit = [.hour, .minute, .weekday]
                let myComponents = myCalendar?.components(unitFlags, from: self.picker.date)
                let hour = myComponents?.hour
                let minute = myComponents?.minute
                let day = self.returnDayFromWeekDayInt(weekDay:  (myComponents?.weekday!)!)
                let updateHour = NSNumber(value: hour!)
                let updateMinute = NSNumber(value: minute!)
                formatter.timeStyle = .none
                let dateString = NSString(string: formatter.string(from: self.picker.date))
                let name = NSString(string: (notification?.user?.name)!)
                let value = ["Day": day as NSString, "StartHour": updateHour, "StartMinute": updateMinute, "DateString": dateString, "Name": name]
                let otherRef = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("Reminders").child(day).child((notification?.user?.uid)!)
                
                otherRef.updateChildValues(value)
                print(timeString1, "This is your timeString")
                let value2 = ["Message": messageString, "OtherUID": sendingID, "Type": typeString,  "profileImageURL": imageURLString, "name": globalCurrentName as NSString, "read": "false" as NSString, "ReminderDate": timeString1 as NSString] as [String : AnyObject]
                let ref = FIRDatabase.database().reference().child("users").child((notification?.otherUID)!).child("Notifications")
                ref.childByAutoId().updateChildValues(value2)
                
                
            }))
            
            self.present(self.dateAlert, animated: true, completion: nil)
           
            //you probably don't want to set background color as black
            //picker.backgroundColor = UIColor.blackColor()
            
            
//            
//            
//            
//
            
        }))
            alert.addAction(UIAlertAction(title: "Can't Make It", style: .default, handler: { (error) in
            let alert = UIAlertController(title: "Send a note", message: "Tell them why it couldn't work.", preferredStyle: .alert)
                alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Send a message..."
                
                })
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (error) in
                let tf = alert.textFields?[0].text
//                let value = ["Message": tf as NSString, "OtherUID": NSString(string: (FIRAuth.auth()?.currentUser?.uid)!), "Type": "Meeting",  "profileImageURL": imageURLString, "name": globalCurrentName as NSString, "read": readString as NSString, "Time": timeString as NSString, "RecruiterNote": recruiterNote]
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            }))
        
        present(alert, animated: true, completion: nil)
    
    }
    
    //Call if you click on the notification
    func changeRead(notification: Notification) {
        let ref = FIRDatabase.database().reference().child("users").child(uid!).child("Notifications").child(notification.number!).child("read")
        
        ref.setValue(["read": "true" as NSString])
        
    }
    
    func handleMoveToMessages() {
        let segueController = MessagesController()
        present(segueController, animated: false, completion: nil)
    }
    
    
    
    
    //Go to search
    func handleMoveToSearch() {
        let segueController = SearchViewController(nibName: nil, bundle: nil)
        segueController.previousController = NotificationCenterViewController()
        present(segueController, animated: false, completion: nil)
    }
    func moveToProfile(sender: UIButton) {
        
        let segueController = ProfilePageViewController()
        present(segueController, animated: false, completion: nil)
    }
    func handleNotifications() {
        let segueController = NotificationCenterViewController()
        present(segueController, animated: false, completion: nil)
    }
    
    func handleMoveToRecruiter() {
        
        //Global feed string is the opposite of what the actual position is fml rahul
        if (globalFeedString == "Student") {
            
            let segueController = CalendarViewController()
            segueController.modalTransitionStyle = .flipHorizontal
            segueController.modalPresentationStyle = .popover
            present(segueController, animated: false, completion: nil)
        } else {
            let segueController = SetUpFreeTimeViewController()
            present(segueController, animated: false, completion: nil)
        }
    }
    
    func errorHandleMeetings() {
        let alert = UIAlertController(title: "Meeting Set", message: "This meeting has already been set", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
 
   
    func createMastHead() {
        self.view.backgroundColor = UIColor(red: (0/255.0), green: (204/255.0), blue: (255/255.0), alpha: 1)
        let gradientLayer = CAGradientLayer()
        let topColor = UIColor(red: (107/255.0), green: (202/255.0), blue: (253/255.0), alpha: 1 )
        let bottomColor = UIColor(red: (105/255.0), green: (160/255.0), blue: (252/255.0), alpha: 0.7 )
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 60)
        view.layer.addSublayer(gradientLayer)
        
        let titleLabel = UILabel()
        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        titleLabel.text = "Elevated Pitch"
        titleLabel.textColor = UIColor.white
        titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -10).isActive = true
        let searchIcon = UIButton()
        self.view.addSubview(searchIcon)
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchIcon.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        searchIcon.topAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        let searchImage = UIImage(named: "searchIcon")
        let searchTinted = searchImage?.withRenderingMode(.alwaysTemplate)
        searchIcon.setBackgroundImage(searchTinted, for: .normal)
        searchIcon.tintColor = UIColor.white
        searchIcon.addTarget(self, action: #selector(handleMoveToSearch), for: .touchUpInside)
        searchIcon.centerXAnchor.constraint(equalTo: self.view.leftAnchor, constant: (self.view.bounds.width / 2 - titleLabel.intrinsicContentSize.width / 2) / 2).isActive = true
        searchIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        searchIcon.addTarget(self, action: #selector(handleMoveToSearch), for: .touchUpInside)
        
        let notificationIcon = UIButton()
        self.view.addSubview(notificationIcon)
        notificationIcon.translatesAutoresizingMaskIntoConstraints = false
        notificationIcon.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        notificationIcon.topAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        notificationIcon.centerXAnchor.constraint(equalTo: self.view.rightAnchor, constant: (titleLabel.intrinsicContentSize.width / 2 - self.view.bounds.width / 2) / 2).isActive = true
        notificationIcon.widthAnchor.constraint(equalToConstant: 32).isActive = true
        let notificationImage = UIImage(named: "notificationIcon")
        let notificationTinted = notificationImage?.withRenderingMode(.alwaysTemplate)
        notificationIcon.setBackgroundImage(notificationTinted, for: .normal)
        notificationIcon.tintColor = UIColor.gray
        
        let containerView = UIView()
        self.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        containerView.backgroundColor = UIColor.white
        containerView.layer.borderColor = UIColor.darkGray.cgColor
        containerView.layer.borderWidth = 0.5
        
        
        
        let width = self.view.bounds.width / 8
        let feedIcon = UIButton()
        self.view.addSubview(feedIcon)
        feedIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        feedIcon.translatesAutoresizingMaskIntoConstraints = false
        feedIcon.widthAnchor.constraint(equalToConstant: width / 1.5).isActive = true
        feedIcon.centerXAnchor.constraint(equalTo: self.view.leftAnchor, constant: width).isActive = true
        feedIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        let feedImage = UIImage(named: "HomeIcon")
        feedIcon.setBackgroundImage(feedImage, for: .normal)
        feedIcon.addTarget(self, action: #selector(handleMoveToFeed), for: .touchUpInside)
        
        let calendarIcon = UIButton()
        self.view.addSubview(calendarIcon)
        calendarIcon.translatesAutoresizingMaskIntoConstraints = false
        calendarIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        calendarIcon.widthAnchor.constraint(equalToConstant: width / 1.5).isActive = true
        calendarIcon.centerXAnchor.constraint(equalTo: self.view.leftAnchor, constant: 3 * width).isActive = true
        calendarIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        calendarIcon.setBackgroundImage(UIImage(named: "CalendarIcon"), for: .normal)
        calendarIcon.addTarget(self, action: #selector(handleMoveToRecruiter), for: .touchUpInside)
        let messageIcon = UIButton()
        self.view.addSubview(messageIcon)
        messageIcon.translatesAutoresizingMaskIntoConstraints = false
        messageIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        messageIcon.widthAnchor.constraint(equalToConstant: width / 1.5).isActive = true
        messageIcon.centerXAnchor.constraint(equalTo: self.view.rightAnchor, constant: -3 * width).isActive = true
        messageIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        messageIcon.setBackgroundImage(UIImage(named: "MessageIcon-1"), for: .normal)
        messageIcon.addTarget(self, action: #selector(handleMoveToMessages), for: .touchUpInside)
        
        let profileIcon = UIButton()
        self.view.addSubview(profileIcon)
        profileIcon.translatesAutoresizingMaskIntoConstraints = false
        profileIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        profileIcon.widthAnchor.constraint(equalToConstant: width / 1.5).isActive = true
        profileIcon.centerXAnchor.constraint(equalTo: self.view.rightAnchor, constant: -width).isActive = true
        profileIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        let profileIconImage = UIImage(named: "ProfileImage")
        profileIcon.setBackgroundImage(profileIconImage, for: .normal)
        profileIcon.addTarget(self, action: #selector(moveToProfile), for: .touchUpInside)
        
        
        
        
        
    }

    
    //Set up the notifications
    func fetchNotifications() {
        
        ref.child(uid!).child("Notifications").observe(.childAdded, with: { (snapshot) in
            
            let dictionary = snapshot.value as? [String: AnyObject]
            var notification = Notification()
            notification.user = User()
            if (dictionary?["Type"] as? String != nil ) {
            notification.type = dictionary?["Type"] as! String?
            }
            if (dictionary?["Message"] as? String != nil ) {

            notification.message = dictionary?["Message"] as! String?
            }
            if (dictionary?["OtherUID"] as? String != nil) {
            notification.otherUID = (dictionary?["OtherUID"] as? String?)!
            }
            if (dictionary?["profileImageURL"] as? String != nil) {
            notification.profileImageURL = (dictionary?["profileImageURL"] as? String?)!
            }
            notification.user?.uid = notification.otherUID!
            if (dictionary?["name"] as? String != nil) {
            notification.user?.name = (dictionary?["name"] as? String)!
            }
            if (dictionary?["read"] as? String != nil) {
            notification.read = (dictionary?["read"] as? String)!
            }
            if (notification.type == "Friend") {
                if (dictionary?["Occupation"] as? String != nil) {
                notification.user?.occupation = (dictionary?["Occupation"] as? String)!
                }
            }
            if (notification.type  == "Meeting") {
                notification.timeString = dictionary?["Time"] as? String
                notification.extraNote = dictionary?["RecruiterNote"] as? String
            }
            
            if (notification.type == "Accepted") {
                notification.timeString = dictionary?["ReminderDate"] as? String
                
            }
            
            notification.number = snapshot.key
            self.notificationList.append(notification)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
            
            
            
        })
        
    }
    
  
        class SendButton: UIButton  {
            var user = User()
            var notification: Notification?
        }
    
    
    
    //----------------------------------------------------------------------------------------
    //TABLE VIEW SET UP
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let realRow = notificationList.count - indexPath.row 
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        let width = cell.bounds.width
        let height = cell.bounds.height
        if (notificationList.count == 0) {
            tableView.backgroundColor = UIColor.lightGray
            cell.backgroundColor = UIColor.lightGray
            let errorLabel = UILabel()
            cell.addSubview(errorLabel)
            errorLabel.translatesAutoresizingMaskIntoConstraints = false
            errorLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            errorLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            errorLabel.text = "No Notifications"
            errorLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 24)
            errorLabel.textColor = UIColor.darkGray
        }
        else {
            if (indexPath.row == 0) {
                let titleLabel = UILabel()
                cell.addSubview(titleLabel)
                titleLabel.translatesAutoresizingMaskIntoConstraints = false
                titleLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
                titleLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
                titleLabel.font = UIFont(name: "AppleSDGothicNeo", size: 20)
                titleLabel.text = "Activity"
            } else {
                
            
        cell.layer.borderWidth = 0.5
        let cellButton = SendButton()
        cell.addSubview(cellButton)
        cellButton.translatesAutoresizingMaskIntoConstraints = false
        cellButton.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        cellButton.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        cellButton.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        cellButton.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
        cellButton.notification = notificationList[realRow]
        cellButton.user = notificationList[realRow].user!
        cellButton.user.previousController = NotificationCenterViewController()
        
        cell.layer.borderColor = UIColor.gray.cgColor
        let profileImageView = UIImageView()
        cell.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: width / 5).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: width / 5).isActive = true
        profileImageView.loadImageUsingCacheWithURLString(urlString:notificationList[realRow].profileImageURL!)
        profileImageView.centerXAnchor.constraint(equalTo: cell.leftAnchor, constant: 40).isActive = true

        let messageLabel = UILabel()
        cell.addSubview(messageLabel)
        messageLabel.text = notificationList[realRow].message
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true

        messageLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 20).isActive = true
        messageLabel.topAnchor.constraint(equalTo: cell.topAnchor, constant: -30).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 30).isActive = true
        messageLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        messageLabel.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        
      
                
        let type = notificationList[realRow].type

        if cellButton.notification?.read == "false"  {
            cell.backgroundColor = UIColor(red: (107/255.0), green: (204/255.0), blue: (253/255.0), alpha: 1)
            
            if (type == "Message") {
                cellButton.addTarget(self, action: #selector(handleMessageType), for: .touchUpInside)
            }
            else if (type == "Friend") {
                cellButton.addTarget(self, action: #selector(handleFriendType), for: .touchUpInside)
            } else if (type == "Meeting") {
                cellButton.addTarget(self, action: #selector(handleMeetingType), for: .touchUpInside)
            } else {
                cellButton.addTarget(self, action: #selector(handleAcceptedType), for: .touchUpInside)
            }
            
        } else {
            if (type == "Meeting" || type == "Accepted") {
                cellButton.addTarget(self, action: #selector(errorHandleMeetings), for: .touchUpInside)
            }
            cell.backgroundColor = UIColor.white
        }
      
       

    }
}
return cell
        
        
}
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (notificationList.count == 0) {
            return 1
        }
        return notificationList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 45
        }
       return 100
    }
    
    
    
    
        
}




