//
//  SetUpFreeTimeViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 7/13/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import Foundation
import UIKit
import Firebase

//This is what gets displayed after you choose a date. List of student's reminders
class StudentScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //INITIALIZATION OF VARIABLES
    
    
    let dayDictionary = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var tableView = UITableView()
    var timeString1: String?
    var timeString2: String?
    var user = User()
    
    var checkList = [String: Array<Reminder>]()
    var titleLabel = UILabel()
    
    //-------------------------------------------------------------------------------------------
    
    
    
    class schedule: UIButton {
        var timeLabel = String()
        
    }
    //HELPER FUNCTIONS AND VIEW DID LOAD
    
    //Fetch your list of remindersu
    
    func deleteReminder(id: String) {
        let ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("Personal Reminders")
        ref.child(id).removeValue(completionBlock: { (error, ref) in
            if error != nil {
                let alert = UIAlertController(title: "Failure", message: "Could not delete reminder", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            
            
        })
    }
    
    
  
    
 
    func fetchReminders() {
        let ref = FIRDatabase.database().reference().child("users").child(user.uid).child("Personal Reminders")
        ref.observe(.childAdded, with: { (snapshot) in
            let dictionary = snapshot.value as? [String: AnyObject]
            var reminder = Reminder()
            
            reminder.day = (dictionary?["Day"] as? String)!
            reminder.startHour = dictionary!["StartHour"] as? NSNumber as! Int
            reminder.startMinute = dictionary!["StartMinute"] as? NSNumber as! Int
            reminder.endHour = dictionary!["EndHour"] as? NSNumber as! Int
            reminder.endMinute = dictionary!["EndMinute"] as? NSNumber as! Int
            reminder.id = snapshot.key
            
            var dateComponents = DateComponents()
            dateComponents.hour = reminder.startHour
            dateComponents.minute = reminder.startMinute
            dateComponents.second = 0
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            let date = Calendar.current.date(from: dateComponents)
            reminder.timeString1 = formatter.string(from: date!)
            var dateComponents2 = DateComponents()
            dateComponents2.hour = reminder.endHour
            dateComponents2.minute = reminder.endMinute
            dateComponents2.second = 0
            
            reminder.timeString2 = formatter.string(from: Calendar.current.date(from: dateComponents2)!)
            
            
            if (self.checkList[reminder.day]?.count == nil) {
                self.checkList[reminder.day] = [reminder]
            } else {
                self.checkList[reminder.day]?.append(reminder)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        })
    }
    
    
    func handleMoveToReminderView() {
        let segueController = SetReminderViewController1()
        present(segueController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    //Move to your Calendar with the reminders
    func handleMoveToFeed() {
        let segueController = FeedController()
        present(segueController, animated: false, completion: nil)
    }
    
    func handleMoveToMessages() {
        let segueController = MessagesController()
        present(segueController, animated: false, completion: nil)
    }
    
    
    //Go to search
    func handleMoveToSearch() {
        let segueController = SearchViewController(nibName: nil, bundle: nil)
        segueController.previousController = FeedController()
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
    
    func scheduleMeeting(sender: schedule) {
        let alert = UIAlertController(title: "Meeting", message: "Would you like to schedule a meeting at this time?", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Add a note"
        })
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (error) in
            let tf = alert.textFields?[0].text
            var string = globalCurrentName
            string.append(" wants to meet.")
            let messageString = string as NSString
            let typeString = "Meeting" as NSString
            let imageURLString = globalProfilePictureImageURL as NSString
            var recruiterNote = NSString()
            if (tf != "") {
            recruiterNote = NSString(string: tf!)
            } else {
            recruiterNote = NSString(string: "")
            }
            let readString = "false"
            let timeString = sender.timeLabel
            let value = ["Message": messageString, "OtherUID": NSString(string: (FIRAuth.auth()?.currentUser?.uid)!), "Type": typeString,  "profileImageURL": imageURLString, "name": globalCurrentName as NSString, "read": readString as NSString, "Time": timeString as NSString, "RecruiterNote": recruiterNote] as [String : AnyObject]
            
            
            FIRDatabase.database().reference().child("users").child(self.user.uid).child("Notifications").childByAutoId().updateChildValues(value)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
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
        
        
        let topView = UIView()
        self.view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        topView.bottomAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        topView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        let titleLabel = UILabel()
        topView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        titleLabel.text = "Elevated Pitch"
        titleLabel.textColor = UIColor.white
        titleLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 10).isActive = true
        
        let searchIcon = UIButton()
        topView.addSubview(searchIcon)
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchIcon.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        searchIcon.topAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        searchIcon.addTarget(self, action: #selector(handleMoveToSearch), for: .touchUpInside)
        let searchImage = UIImage(named: "searchIcon")
        let searchTinted = searchImage?.withRenderingMode(.alwaysTemplate)
        searchIcon.setBackgroundImage(searchTinted, for: .normal)
        searchIcon.tintColor = UIColor.white
        
        searchIcon.centerXAnchor.constraint(equalTo: topView.leftAnchor, constant: (self.view.bounds.width / 2 - titleLabel.intrinsicContentSize.width / 2) / 2).isActive = true
        searchIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        let notificationIcon = UIButton()
        topView.addSubview(notificationIcon)
        notificationIcon.translatesAutoresizingMaskIntoConstraints = false
        notificationIcon.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        notificationIcon.topAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        notificationIcon.centerXAnchor.constraint(equalTo: topView.rightAnchor, constant: (titleLabel.intrinsicContentSize.width / 2 - self.view.bounds.width / 2) / 2).isActive = true
        notificationIcon.widthAnchor.constraint(equalToConstant: 32).isActive = true
        notificationIcon.addTarget(self, action: #selector(handleNotifications), for: .touchUpInside)
        let notificationImage = UIImage(named: "notificationIcon")
        let notificationTinted = notificationImage?.withRenderingMode(.alwaysTemplate)
        notificationIcon.setBackgroundImage(notificationTinted, for: .normal)
        notificationIcon.tintColor = UIColor.white
        
        
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
        let calendarPic = UIImage(named: "CalendarIcon")
        let calendarTinted = calendarPic?.withRenderingMode(.alwaysTemplate)
        calendarIcon.setBackgroundImage(calendarTinted, for: .normal)
        calendarIcon.tintColor = UIColor(red: 100/255, green: 149/255, blue: 245/255, alpha: 1)
        
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
    
    func handleMoveToOtherCalendar() {
        let segueControlelr = SetUpFreeTimeViewController()
        present(segueControlelr, animated: true, completion: nil)
    }
    
    
    
    
    //View did Load
    override func viewDidLoad() {
        fetchReminders()
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60).isActive = true
        createMastHead()
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        containerView.layer.backgroundColor = UIColor.white.cgColor
        
        let titleLabel = UILabel()
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        titleLabel.text = "Calendar"
        
        
        
        
    }
    
    
    
    //-------------------------------------------------------------
    
    //SET UP TABLE VIEW
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (checkList.count == 0) {
            return 1
        }
        if (checkList[dayDictionary[section]]?.count == nil) {
            return 0
        }
        return (checkList[dayDictionary[section]]?.count)!
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if checkList.count == 0 {
            return 1
        }
        
        return 7
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if checkList[dayDictionary[section]]?.count == nil {
            return ""
        }
        return dayDictionary[section]
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CustomCell(style: .subtitle, reuseIdentifier: "CellID")
        
        
        if checkList.count == 0 {
            tableView.separatorStyle = .none
            cell.selectionStyle = .none
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
        } else {
            tableView.backgroundColor = UIColor.white
            
            let timeLabel1 = UILabel()
            let timeLabel2 = UILabel()
            if ( checkList[dayDictionary[indexPath.section]]?.count != 0) {
                let reminderArray = checkList[dayDictionary[indexPath.section]]
                var reminder = Reminder()
                reminder = (reminderArray?[indexPath.row])!
                timeLabel1.text = reminder.timeString1
                timeLabel2.text = reminder.timeString2
                cell.addSubview(timeLabel1)
                cell.addSubview(timeLabel2)
                timeLabel1.translatesAutoresizingMaskIntoConstraints = false
                timeLabel2.translatesAutoresizingMaskIntoConstraints = false
                
                timeLabel1.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
                timeLabel2.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 14)
                timeLabel1.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 5).isActive = true
                timeLabel1.topAnchor.constraint(equalTo: cell.topAnchor, constant: 5).isActive = true
                timeLabel2.leftAnchor.constraint(equalTo: timeLabel1.leftAnchor).isActive = true
                timeLabel2.topAnchor.constraint(equalTo: timeLabel1.bottomAnchor, constant: 3).isActive = true
                let lineSeparatorView = UIView()
                cell.addSubview(lineSeparatorView)
                lineSeparatorView.translatesAutoresizingMaskIntoConstraints = false
                lineSeparatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
                lineSeparatorView.heightAnchor.constraint(equalToConstant: cell.bounds.height * 0.8).isActive = true
                lineSeparatorView.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: cell.bounds.width * 0.2).isActive = true
                lineSeparatorView.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
                lineSeparatorView.layer.borderWidth = 1
                
                let nameLabel = UILabel()
                cell.addSubview(nameLabel)
                nameLabel.text = "Available"
                nameLabel.translatesAutoresizingMaskIntoConstraints = false
                nameLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
                nameLabel.leftAnchor.constraint(equalTo: lineSeparatorView.rightAnchor, constant: 5).isActive = true
                nameLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
                
                
                let scheduleButton = schedule()
                cell.addSubview(scheduleButton)
                scheduleButton.timeLabel = dayDictionary[indexPath.section]
                scheduleButton.timeLabel.append(", ")
                scheduleButton.timeLabel.append(timeLabel1.text!)
                scheduleButton.timeLabel.append(" to ")
                scheduleButton.timeLabel.append(timeLabel2.text!)
                scheduleButton.translatesAutoresizingMaskIntoConstraints = false
                
                scheduleButton.addTarget(self, action: #selector(scheduleMeeting), for: .touchUpInside)
                scheduleButton.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
                scheduleButton.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
                scheduleButton.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
                scheduleButton.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
                scheduleButton.backgroundColor = UIColor.clear
                
            }
        }
        return cell
    }
}


