//
//  RecruiterCalendarViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 7/17/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import Foundation
import UIKit
import Firebase

//This is your table View list of reminders
class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //Initialization of variables. 
    
    let dayDictionary = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var helpView = UIView()
    
    
    //-----------------------------------------------------------------------
    
    //HELPER FUNCTIONS AND VIEWDIDLOAD
    
    
    
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
        
        helpLabel.text = "This is where you can set meetings with other users.  If you're a recruiter, go to a student's profile and check out the times they're free to set a meeting."
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

    //Student times to display in the tableView
    func fetchStudentTimes() {
        
            let ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("Reminders")
            ref.observe(.value, with: { (snapshot) in
                if (snapshot.value as? [String: AnyObject] != nil) {
                let dictionary = snapshot.value as! [String: AnyObject]
                
                for day in self.dayDictionary {
                    if (dictionary[day] != nil) {
                        let intermediateDic = dictionary[day] as! [String: AnyObject]
                        for i in 0..<intermediateDic.count {
                            var dictionary2 = [String: AnyObject]()
                            dictionary2 = intermediateDic[intermediateDic.index(intermediateDic.startIndex, offsetBy: i)].value as! [String: AnyObject]
                            var reminder = Reminder()
                            reminder.day = day
                            reminder.startHour = (dictionary2["StartHour"] as? Int)!
                            reminder.startMinute = (dictionary2["StartMinute"] as? Int)!
                            reminder.id = intermediateDic[intermediateDic.index(intermediateDic.startIndex, offsetBy: i)].key
                            if (dictionary2["Name"] as? String != nil) {
                                reminder.name = (dictionary2["Name"] as? String)!
                            }
                            if (dictionary2["DateString"] as? String != nil) {
                                reminder.timeString2 = dictionary2["DateString"] as! String
                            }
                            var dateComponents1 = DateComponents()
                            dateComponents1.hour = reminder.startHour
                            dateComponents1.minute = reminder.startMinute
                            dateComponents1.second = 0
                            
                            let formatter = DateFormatter()
                            formatter.timeStyle = .short
                            reminder.timeString1 = formatter.string(from: Calendar.current.date(from: dateComponents1)!)
                            
                            
                            
                            formatter.timeStyle = .none
                            formatter.dateStyle = .short
                            var date = formatter.date(from: reminder.timeString2)
                            
                            let calendar = Calendar.current
                            var dateComponents = DateComponents()
                            
                            
                            dateComponents1.month = calendar.component(.month, from: date!)
                            dateComponents1.day = calendar.component(.day, from: date!)
                            date = calendar.date(from: dateComponents1)!

                            let now = Date()
                            dateComponents1.year = calendar.component(.year, from: now)
                            date = calendar.date(from: dateComponents1)!

                            if (date! >= now) {
                            if (self.checkList[reminder.day]?.count == nil) {
                                self.checkList[reminder.day] = [reminder]
                            } else {
                                self.checkList[reminder.day]?.append(reminder)
                            }
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                                    
                            }

                            } else {
                                self.deleteReminder(id: reminder.id)
                        }
                    }
                }

                
            
                
            
            
            }
                }
            })
        }
    
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
    
    
    
    
    var tableView = UITableView()
    var checkList = [String: Array<Reminder>]()
    var titleLabel = UILabel()
    

    
    
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

    
    //View did Load
    override func viewDidLoad() {
        fetchStudentTimes()
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
     
//        let key = checkList[checkList.index(checkList.startIndex, offsetBy: section)].key
//        return (checkList[key]?.count)!
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
//        if (checkList.count != 0) {
//        return checkList[checkList.index(checkList.startIndex, offsetBy: section)].key
//        }
//        return ""
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
            
            nameLabel.text = "Meeting with "
            nameLabel.text?.append(reminder.name)
            
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            nameLabel.leftAnchor.constraint(equalTo: lineSeparatorView.rightAnchor, constant: 5).isActive = true
            nameLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        
        }
        }
        return cell
    }
}
