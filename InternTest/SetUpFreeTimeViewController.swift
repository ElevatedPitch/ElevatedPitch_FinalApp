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
class SetUpFreeTimeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //INITIALIZATION OF VARIABLES 
    

    let dayDictionary = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"] 
    var tableView = UITableView()
    var timeString1: String?
    var timeString2: String?
    
    
    var checkList = [String: Array<Reminder>]()
    var titleLabel = UILabel()
    let editButton = UIButton()

    var helpView = UIView()
    
    //-------------------------------------------------------------------------------------------
    
    //HELPER FUNCTIONS AND VIEW DID LOAD 
    
    class actionGesture: UILongPressGestureRecognizer {
        var day: String?
        var row: Int = 0
    }
    class reminderButton: UIButton {
        var reminder = Reminder()
        
    }
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
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func setUpEdit() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        if (tableView.isEditing) {
            editButton.setTitle("Done", for: .normal)
            
        } else {
            editButton.setTitle("Edit", for: .normal)
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
        let day = dayDictionary[indexPath.section]
            
        let reminderArray = checkList[day]
        var reminder = Reminder()
        reminder = (reminderArray?[indexPath.row])!
        checkList[day]?.remove(at: indexPath.row)
        deleteReminder(id: reminder.id)
            DispatchQueue.main.async {
        tableView.reloadData()
            }
        }

        
    }
    func fetchReminders() {
        let ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("Personal Reminders")
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
  
    
    func handleEdit(sender: reminderButton) {
        let segueController = EditTimeViewController(nibName: nil, bundle: nil)
        segueController.reminder = sender.reminder
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
    
    func setUpHelpView() {
        self.view.addSubview(helpView)
        helpView.translatesAutoresizingMaskIntoConstraints = false
        helpView.heightAnchor.constraint(equalToConstant: self.view.bounds.height / 2.3).isActive = true
        helpView.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.8).isActive = true
        helpView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        helpView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        helpView.backgroundColor = UIColor.white
        helpView.layer.borderColor = UIColor.black.cgColor
        helpView.layer.borderWidth = 1
        helpView.layer.cornerRadius = 5
        let titleLabel = UILabel()
        helpView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Welcome to Calendar"
        titleLabel.centerXAnchor.constraint(equalTo: helpView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: helpView.topAnchor, constant: 10).isActive = true
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        
        
        let helpLabel = UILabel()
        helpView.addSubview(helpLabel)
        helpLabel.translatesAutoresizingMaskIntoConstraints = false
        
        helpLabel.text = "This is where you can set the times that you are free for phone call, video chat, etc meetings with recruiters. Ensure these are times you will be free every week. If you want to delete a time, swipe to the right like it's a text. "
        helpLabel.numberOfLines = 0
        helpLabel.lineBreakMode = .byWordWrapping
        helpLabel.centerXAnchor.constraint(equalTo: helpView.centerXAnchor).isActive = true
        helpLabel.centerYAnchor.constraint(equalTo: helpView.centerYAnchor).isActive = true
        helpLabel.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.7).isActive = true
        helpLabel.textAlignment = .center
        helpLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        tableView.alpha = 0.8
        
        let continueButton = UIButton()
        helpView.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.centerXAnchor.constraint(equalTo: helpView.centerXAnchor).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.5).isActive = true
        continueButton.topAnchor.constraint(equalTo: helpLabel.bottomAnchor, constant: 20).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        continueButton.setTitle("Get Started", for: .normal)
        continueButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.layer.cornerRadius = 10
        continueButton.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
        continueButton.addTarget(self, action: #selector(removeHelpView), for: .touchUpInside)
        
        
        
    }
    
    
    func removeHelpView() {
        helpView.removeFromSuperview()
        tableView.alpha = 1
        let ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("HelpViews")
        firstTimeCalendar = false
        let value = ["FirstTimeCalendar": "false" as NSString]
        ref.updateChildValues(value)
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
        
        containerView.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        editButton.setTitle("Edit", for: .normal)
        editButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        editButton.setTitleColor(UIColor.blue, for: .normal)
        editButton.addTarget(self, action: #selector(setUpEdit) , for: .touchUpInside)
        
        
        let notificationIcon = UIButton()
        containerView.addSubview(notificationIcon)
        notificationIcon.translatesAutoresizingMaskIntoConstraints = false
        notificationIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        notificationIcon.centerXAnchor.constraint(equalTo: containerView.rightAnchor, constant: (titleLabel.intrinsicContentSize.width / 2 - self.view.bounds.width / 2) / 2).isActive = true
        notificationIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        notificationIcon.widthAnchor.constraint(equalToConstant: 32).isActive = true
        notificationIcon.addTarget(self, action: #selector(handleMoveToReminderView), for: .touchUpInside)
        let notificationImage = UIImage(named: "AddIcon")
        let notificationTinted = notificationImage?.withRenderingMode(.alwaysTemplate)
        notificationIcon.setBackgroundImage(notificationTinted, for: .normal)
        notificationIcon.tintColor = UIColor.gray
        
        
        if (firstTimeCalendar) {
            setUpHelpView()
            
        }
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
    
    func setUpActionSheet(sender: actionGesture) {
        print(sender.row, "This is row")
        let alert = UIAlertController(title: "Reminder", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (error) in
            let reminderArray = self.checkList[sender.day!]
            self.checkList[sender.day!]?.remove(at: sender.row)
            self.deleteReminder(id: (reminderArray?[sender.row].id)!)
            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if checkList[dayDictionary[section]]?.count == nil {
            return ""
        }
        return dayDictionary[section]
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CustomCell(style: .subtitle, reuseIdentifier: "CellID")
        
        cell.selectionStyle = .none
        
        if checkList.count == 0 {
            tableView.separatorStyle = .none
            
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
            timeLabel1.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 38).isActive = true
            timeLabel1.topAnchor.constraint(equalTo: cell.topAnchor, constant: 5).isActive = true
            timeLabel2.leftAnchor.constraint(equalTo: timeLabel1.leftAnchor).isActive = true
            timeLabel2.topAnchor.constraint(equalTo: timeLabel1.bottomAnchor, constant: 3).isActive = true
            let lineSeparatorView = UIView()
            cell.addSubview(lineSeparatorView)
            lineSeparatorView.translatesAutoresizingMaskIntoConstraints = false
            lineSeparatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
            lineSeparatorView.heightAnchor.constraint(equalToConstant: cell.bounds.height * 0.8).isActive = true
            lineSeparatorView.leftAnchor.constraint(equalTo: timeLabel2.rightAnchor, constant: 10).isActive = true
            lineSeparatorView.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            lineSeparatorView.layer.borderWidth = 1
            
            let nameLabel = UILabel()
            cell.addSubview(nameLabel)
            nameLabel.text = "Available"
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            nameLabel.leftAnchor.constraint(equalTo: lineSeparatorView.rightAnchor, constant: 5).isActive = true
            nameLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
            
            let button = UIButton()
            cell.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
            button.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
            button.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            let longPress = actionGesture(target: self, action: #selector(setUpActionSheet))
            longPress.day = dayDictionary[indexPath.section]
            longPress.row = indexPath.row
            button.addGestureRecognizer(longPress)
            
            let informationButton = reminderButton()
            cell.addSubview(informationButton)
            informationButton.translatesAutoresizingMaskIntoConstraints = false
            informationButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
            informationButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            informationButton.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            informationButton.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -20).isActive = true
            let informationImage = UIImage(named: "informationIcon")
            let informationTinted = informationImage?.withRenderingMode(.alwaysTemplate)
            informationButton.setBackgroundImage(informationTinted, for: .normal)
            informationButton.tintColor = UIColor.blue
            informationButton.reminder = reminder
            informationButton.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
            
        }
        }
        return cell
    }
}


