//
//  StudentViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 3/31/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation
import Firebase


//After a user clicks yes on the feed, they come here to see further information

class StudentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
  
    

    
    
    //Initialization of Variables
    
    
    var user: User? {
        didSet {
            titleLabel.text = user?.name
            
            
        }
    }
    init (user: User) {
        super.init(nibName: nil, bundle: nil)
        
        ({self.user = user})()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    
    //------------------------------------------------------------------------------------
    
    
    //HELPER FUNCTIONS AND VIEW DID LOAD
    
    
    
    
    
    //INITIALIZATION OF VARIABLES
    
    
    class urlTap: UIButton {
        var urlString = String()
    }
    let height = UIScreen.main.bounds.height / 4
    
    var tableView =  UITableView()
    class emailButton: UIButton {
        var userEmail: String = ""
    }
    var profileImageURL: String?
    let headerLabel = UILabel()
    let nameLabel = UILabel()
    let titleLabel = UILabel()
    
    
    let cameraButton = UIButton()
    let messageButton = emailButton()
    let profileImageView  = UIImageView()
    
    var companyLabel = UILabel()
    let positionLabel = UILabel()
    var fullLabel = UILabel()
    let moveToMessageButton = UIButton()
    let videoOneButton = UIButton()
    let videoTwoButton = UIButton()
    let videoThreeButton = UIButton()
    let videoTextLabel = UILabel()
    let uid = FIRAuth.auth()?.currentUser?.uid
    let ai = UIActivityIndicatorView()
    
    var firstVideoImageView = UIImageView()
    var firstVideoURl = String()
    var supplementalImageView = UIImageView()
    var supplementalVideoURL = String()
    var supplementalImageView2 = UIImageView()
    var supplementalVideoURL2 = String()
    var supplementalImageView3 = UIImageView()
    var supplementalVideoURL3 = String()
    
    
    
    let firstSkill = UILabel()
    let secondSkill = UILabel()
    let thirdSkill = UILabel()
    let fourthSkill = UILabel()
    
    
    var linkedInTap = urlTap()
    var githubTap = urlTap()
    var bruinTap = urlTap()
    
    let checkRef = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("Reminders")
    // ----------------------------------------------------------------------
    
    //HELPER FUNCTIONS AND VIEW DID LOAD
    
    func errorHandle1() {
        let alert = UIAlertController(title: "Error", message: "Student already in Reminders", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func errorHandle2() {
        let alert = UIAlertController(title: "Error", message: "User has no times set", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    func moveToLinks() {
        let segueController = StudentLinksViewController(nibName: nil, bundle: nil)
        segueController.user = self.user!
        present(segueController, animated: true, completion: nil)
    }
    
    func fetchReminders() {
        if (globalFeedString == "Employer") {
            let alert = UIAlertController(title: "Error", message: "This feature is for recruiters only", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        let ref = FIRDatabase.database().reference().child("users").child((self.user?.uid)!).child("Personal Reminders")
        
        ref.observeSingleEvent(of: .value, with: { (snapshotTop) in
            if (!snapshotTop.hasChildren()) {
                self.errorHandle2()
                
            } else {
                
                self.checkRef.observe(.value, with: { (snapshot) in
                    if (snapshot.hasChild((self.user?.uid)!)) {
                        self.errorHandle1()
                    } else {
                        self.addReminder()
                    }
                    
                    
                })
            }
        })
    }
    
    
    func addReminder() {
        let ref = FIRDatabase.database().reference().child("users").child((self.user?.uid)!).child("Personal Reminders")
        let ref2 = checkRef.child((self.user?.uid)!)
        
        ref.observe(.childAdded, with:  { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let endMinute = dictionary["EndMinute"] as! NSNumber
                let endHour = dictionary["EndHour"] as! NSNumber
                let startMinute = dictionary["StartMinute"] as! NSNumber
                let startHour = dictionary["StartHour"] as! NSNumber
                let day = dictionary["Day"] as! NSString
                let name = self.titleLabel.text as! NSString
                ref2.child(day as String).childByAutoId().setValue(["StartHour": startHour, "StartMinute": startMinute, "EndHour": endHour, "EndMinute": endMinute, "Name": name])
                
                
                
                var date = Date()
                let calendar = Calendar.current
                var dateComponents = DateComponents()
                
                dateComponents.year = calendar.component(.year, from: date)
                dateComponents.month = calendar.component(.month, from: date)
                dateComponents.weekOfMonth = calendar.component(.weekOfMonth, from: date)
                dateComponents.hour = startHour as Int
                dateComponents.minute = startMinute as Int
                dateComponents.second = 0
                switch day {
                case "Sunday":
                    dateComponents.weekday  = 1
                    break
                case "Monday":
                    dateComponents.weekday = 2
                    break
                case "Tuesday":
                    dateComponents.weekday = 3
                    break
                case "Wednesday":
                    dateComponents.weekday = 4
                    break
                case "Thursday":
                    dateComponents.weekday = 5
                    break
                case "Friday":
                    dateComponents.weekday = 6
                    break
                default:
                    dateComponents.weekday = 7
                    break
                }
                date = calendar.date(from: dateComponents)!
                let now = Date()
                if date < now {
                    date = date.addingTimeInterval(604800)
                }
                let formatter = DateFormatter()
                formatter.timeStyle = .long
                formatter.dateStyle = .long
                let printString = formatter.string(from: date)
                let todoItem = TodoItem()
                
                todoItem.title = "Reminders"
                todoItem.UUID = self.titleLabel.text!
                todoItem.deadline = date
                TodoList.sharedInstance.addItem(item: todoItem)
                
                
            }
            
            
            
            
        })
        let alert = UIAlertController(title: "Success", message: "Added reminders to Calendar", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    deinit {
        profileImageView.removeObserver(self, forKeyPath: "image")
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "image") {
            ai.hidesWhenStopped = true
            ai.stopAnimating()
        }
    }
    
    
    
    //Movement to the rest of the app
    func mastheadMoveToMessages() {
        let segueController = MessagesController()
        present(segueController, animated: false, completion: nil)
    }
    
    
    
    //Go to search
    func handleMoveToSearch() {
        let segueController = SearchViewController(nibName: nil, bundle: nil)
        segueController.previousController = ProfilePageViewController()
        present(segueController, animated: true, completion: nil)
    }
    func moveToProfile(sender: UIButton) {
        
        let segueController = ProfilePageViewController()
        present(segueController, animated: false, completion: nil)
    }
    func handleNotifications() {
        let segueController = NotificationCenterViewController()
        present(segueController, animated: false, completion: nil)
    }
    
    func handleMoveToFeed() {
        let segueController = FeedController()
        present(segueController, animated: false, completion: nil)
    }
    
    
    
    func moveToCamera() {
        let segueController = CameraChooseViewController()
        present(segueController, animated: true, completion: nil)
    }
    
    func moveToMessagesController() {
        let segueController = MessagesController()
        present(segueController, animated: false, completion: nil)
    }
    
    
    func changePassword() {
        
        let segueController = ChangePasswordViewController()
        present(segueController, animated: true, completion: nil)
        
    }
    
    
    //Logout
   
    
    func handleURL(sender: urlTap) {
    if (sender.urlString != "") {
        openURL(url: sender.urlString)
    
    } else {
    let alert = UIAlertController(title: "Failure", message: "No link available. Feel free to message the user.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
    
        }
    }
    
    
    func openURL(url: String) {
        let passedURL = URL(string: url)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(passedURL!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(passedURL!)
        }
    }
    
    func moveToSchedule() {
        let segueController = StudentScheduleViewController(nibName: nil, bundle: nil)
        segueController.user = self.user!
        present(segueController, animated: true, completion: nil)
    }
    
    
    //If you're logged in, load up all of the data
    func checkIfUserLoggedIn() {
       
            let uid = self.user?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    if dictionary["Skill 1"] as! String? != nil {
                        self.firstSkill.text = dictionary["Skill 1"] as! String?
                        
                    } else {
                        self.firstSkill.text = "#placeholder"
                    }
                    
                    if dictionary["Skill 2"] as! String? != nil {
                        self.secondSkill.text = dictionary["Skill 2"] as! String?
                    } else {
                        self.secondSkill.text = "#placeholder"
                        
                    }
                    if dictionary["Skill 3"] as! String? != nil {
                        self.thirdSkill.text = dictionary["Skill 3"] as! String?
                        
                    } else {
                        self.thirdSkill.text = "#placeholder"
                    }
                    if dictionary["Skill 4"] as! String? != nil {
                        self.fourthSkill.text = dictionary["Skill 4"] as! String?
                        
                    } else {
                        self.fourthSkill.text = "#placeholder"
                    }
                    if dictionary["Bio"] as! String? != nil {
                        self.fullLabel.text = dictionary["Bio"] as! String?
                    }
                    
                    if dictionary["name"] as! String? != nil {
                        self.nameLabel.text = dictionary["name"] as! String?
                    } else {
                        self.nameLabel.text = "Placeholder"
                    }
                    
                    if (dictionary["Occupation"] as? String == "Employer") {
                        self.companyLabel.text = dictionary["Company"] as! String
                        self.positionLabel.text = dictionary["Employee Position"] as! String
                    }
                    else {
                        self.companyLabel.text = dictionary["Unversity"] as! String?
                        self.positionLabel.text = dictionary["Major"] as! String?
                    }
                    
                    
                    if dictionary["profileImageURL"] as! String? != nil {
                        
                        self.profileImageURL = dictionary["profileImageURL"] as! String?
                        
                        //                            self.profileImageView.loadImageUsingCacheWithURLString(urlString: profileImageURL)
                        self.profileImageView.loadImageUsingCacheWithURLString(urlString: self.profileImageURL!)
                        
                        
                    } else {
                        self.profileImageURL = "AddIcon"
                    }
                    if dictionary["userVideoURL"] as! String? != nil {
                        self.firstVideoURl = (dictionary["userVideoURL"] as! String?)!
                        if dictionary["thumbnailImageURL"] as! String? != nil {
                            self.firstVideoImageView.loadImageUsingCacheWithURLString(urlString: (dictionary["thumbnailImageURL"] as! String?)!)
                        }
                    } else {
                        self.firstVideoURl = "AddIcon"
                        
                    }
                    
                    if dictionary["experienceSupplementURL"] as! String? != nil {
                        self.supplementalVideoURL = (dictionary["experienceSupplementURL"] as! String?)!
                        if dictionary["experienceThumbnailImage"] as! String? != nil {
                            self.supplementalImageView.loadImageUsingCacheWithURLString(urlString: (dictionary["experienceThumbnailImage"] as! String?)!)
                        }
                    } else {
                        self.supplementalVideoURL = "AddIcon"
                        
                    }
                    
                    if dictionary["skillsSupplementURL"] as! String? != nil {
                        self.supplementalVideoURL2 = (dictionary["skillsSupplementURL"] as! String?)!
                        if dictionary["skillsThumbnailImage"] as! String? != nil {
                            self.supplementalImageView2.loadImageUsingCacheWithURLString(urlString: (dictionary["skillsThumbnailImage"] as! String?)!)
                        }
                        
                    } else {
                        self.supplementalVideoURL2 = "AddIcon"
                        
                    }
                    
                    
                    if dictionary["extraSupplementURL"] as! String? != nil {
                        self.supplementalVideoURL3 = (dictionary["extraSupplementURL"] as! String?)!
                        if dictionary["extraThumbnailImage"] as! String? != nil {
                            self.supplementalImageView3.loadImageUsingCacheWithURLString(urlString: (dictionary["extraThumbnailImage"] as! String?)!)
                            
                        }
                    } else {
                        self.supplementalVideoURL3 = "AddIcon"
                    }
                    
                    if (dictionary["linkedInLink"] as! String? != nil) {
                        self.linkedInTap.urlString = (dictionary["linkedInLink"] as! String?)!
                    }
                    
                    
                    
                    
                    
                    
                }
                
                
                
                
                
            })
            
            
            
        
    }
    
    
    
    
    
    
    
    class playButton: UIButton  {
        var playerURL = String()
    }
    
    
    
    
    func MoveToVideo(sender: playButton) {
        let url = URL(string: sender.playerURL)
        
        
        
        
        let player = AVPlayer(url: (url! as URL))
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true, completion: {
            playerViewController.player?.play()
        })
        
        
        
        
    }
    
    func handleMoveToMessages() {
        
        user?.previousController = StudentViewController(user: user!)
        let segueController = ChatController(user: user!)
        present(segueController, animated: true, completion: nil)
        
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
    
    func handleMoveToProfile() {
        let segueController = ProfilePageViewController()
        present(segueController, animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.5, animations: {
            
            self.profileImageView.alpha = 1.0
        })
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
        notificationIcon.tintColor = UIColor.white
        notificationIcon.addTarget(self, action: #selector(handleNotifications), for: .touchUpInside)
        
        
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
        let feedTinted = feedImage?.withRenderingMode(.alwaysTemplate)
        feedIcon.setBackgroundImage(feedTinted, for: .normal)
        feedIcon.tintColor = UIColor(red: 100/255, green: 149/255, blue: 245/255, alpha: 1)
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
        messageIcon.addTarget(self, action: #selector(mastheadMoveToMessages), for: .touchUpInside)
        
        let profileIcon = UIButton()
        self.view.addSubview(profileIcon)
        profileIcon.translatesAutoresizingMaskIntoConstraints = false
        profileIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        profileIcon.widthAnchor.constraint(equalToConstant: width / 1.5).isActive = true
        profileIcon.centerXAnchor.constraint(equalTo: self.view.rightAnchor, constant: -width).isActive = true
        profileIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        let profileIconImage = UIImage(named: "ProfileImage")
        profileIcon.setBackgroundImage(profileIconImage, for: .normal)
        profileIcon.addTarget(self, action: #selector(handleMoveToProfile), for: .touchUpInside)
        
        
        
        
        
    }
    
    func handleBackMove() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        profileImageView.addObserver(self, forKeyPath: "image", options: NSKeyValueObservingOptions.new, context: nil)
        
        checkIfUserLoggedIn()
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60).isActive = true
        tableView.separatorStyle = .none
        
        
        // Do any additional setup after loading the view.
        
        createMastHead()
        
    }
    
    
    
  
    
    
 
    
    
    
   
    
    //TABLEVIEW SETUP
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 60
        case 1:
            return 150
        case 2:
            return 150
        case 3:
            return height + 100
        case 4:
            return 3 * height + 300
        case 5:
            return 220
        default:
            return 70
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CellID")
        cell.layer.borderWidth = 1.0
        cell.selectionStyle = .none
        
        cell.layer.borderColor = UIColor.gray.cgColor
        switch indexPath.row {
        case 0:
            cell.addSubview(nameLabel)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            nameLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            nameLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 26)
            
            
            let messageIndividualButton = UIButton()
            cell.addSubview(messageIndividualButton)
            messageIndividualButton.translatesAutoresizingMaskIntoConstraints = false
            messageIndividualButton.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -25).isActive = true
            messageIndividualButton.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            messageIndividualButton.heightAnchor.constraint(equalToConstant: cell.bounds.height * 0.7).isActive = true
            messageIndividualButton.widthAnchor.constraint(equalToConstant: cell.bounds.height * 0.8).isActive = true
            messageIndividualButton.setImage(UIImage(named: "MessageIcon-1"), for: .normal)
            messageIndividualButton.addTarget(self, action: #selector(handleMoveToMessages), for: .touchUpInside)
            
            let backButton = UIButton()
            cell.addSubview(backButton)
            backButton.translatesAutoresizingMaskIntoConstraints = false
            backButton.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 10).isActive = true
            backButton.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            backButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
            backButton.widthAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
            backButton.setImage(UIImage(named: "arrowIcon"), for: .normal)
            backButton.addTarget(self, action: #selector(handleBackMove), for: .touchUpInside)
            backButton.contentEdgeInsets = UIEdgeInsetsMake( -3, -3, -3, -3)
            
            break
        case 1:
            cell.addSubview(profileImageView)
            profileImageView.translatesAutoresizingMaskIntoConstraints = false
            profileImageView.centerXAnchor.constraint(equalTo: cell.leftAnchor, constant: 60).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            profileImageView.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            profileImageView.layer.borderWidth = 0.5
            if (profileImageURL == "AddIcon") {
                profileImageView.image = UIImage(named: "VideoUnavailable")
                let profileButton = UIButton()
                cell.addSubview(profileButton)
                
            }
            cell.addSubview(ai)
            ai.translatesAutoresizingMaskIntoConstraints = false
            ai.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
            ai.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
            ai.rightAnchor.constraint(equalTo: profileImageView.rightAnchor).isActive = true
            ai.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
            ai.color = UIColor.black
            if (profileImageURL == nil) {
                ai.startAnimating()
            }
            
                       cell.addSubview(fullLabel)
            fullLabel.translatesAutoresizingMaskIntoConstraints = false
            fullLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
            fullLabel.widthAnchor.constraint(equalToConstant: cell.bounds.width * 0.6).isActive = true
            fullLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 15).isActive = true
            fullLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
            fullLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
            
            fullLabel.lineBreakMode = .byWordWrapping
            fullLabel.numberOfLines = 0
            break
            
        case 2:
            let skillLabel = UILabel()
            cell.addSubview(skillLabel)
            skillLabel.text = "My Skills"
            skillLabel.translatesAutoresizingMaskIntoConstraints = false
            skillLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            skillLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 24)
            skillLabel.topAnchor.constraint(equalTo: cell.topAnchor, constant: 10).isActive = true
            let skillLabelWidth = cell.bounds.width * 0.75 * 0.5
            
            
            
            let firstSkillContainerView = UIView()
            
            cell.addSubview(firstSkillContainerView)
            firstSkillContainerView.addSubview(firstSkill)
            firstSkillContainerView.translatesAutoresizingMaskIntoConstraints = false
            firstSkillContainerView.widthAnchor.constraint(equalToConstant: skillLabelWidth).isActive = true
            firstSkillContainerView.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: (cell.bounds.width - skillLabelWidth) / 6).isActive = true
            firstSkillContainerView.topAnchor.constraint(equalTo: skillLabel.bottomAnchor, constant: 10).isActive = true
            firstSkillContainerView.heightAnchor.constraint(equalTo: firstSkill.heightAnchor).isActive = true
            firstSkillContainerView.layer.borderWidth = 0.5
            firstSkillContainerView.layer.borderColor = UIColor.gray.cgColor
            firstSkillContainerView.layer.masksToBounds = true
            
            
            
            firstSkill.translatesAutoresizingMaskIntoConstraints = false
            firstSkill.centerXAnchor.constraint(equalTo: firstSkillContainerView.centerXAnchor).isActive = true
            firstSkill.centerYAnchor.constraint(equalTo: firstSkillContainerView.centerYAnchor).isActive = true
            firstSkill.font = UIFont(name: "AppleSDGothicNeo-Light", size: 18)
            
            
            let secondSkillContainerView = UIView()
            cell.addSubview(secondSkillContainerView)
            secondSkillContainerView.addSubview(secondSkill)
            secondSkillContainerView.translatesAutoresizingMaskIntoConstraints = false
            secondSkillContainerView.topAnchor.constraint(equalTo: firstSkillContainerView.topAnchor).isActive = true
            secondSkillContainerView.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: (skillLabelWidth - cell.bounds.width) / 6).isActive = true
            secondSkillContainerView.widthAnchor.constraint(equalTo: firstSkillContainerView.widthAnchor).isActive = true
            secondSkillContainerView.heightAnchor.constraint(equalTo: firstSkillContainerView.heightAnchor).isActive = true
            secondSkillContainerView.layer.borderWidth = 0.5
            secondSkillContainerView.layer.borderColor = UIColor.gray.cgColor
            secondSkillContainerView.layer.masksToBounds = true
            
            secondSkill.translatesAutoresizingMaskIntoConstraints = false
            secondSkill.centerXAnchor.constraint(equalTo: secondSkillContainerView.centerXAnchor).isActive = true
            secondSkill.centerYAnchor.constraint(equalTo: secondSkillContainerView.centerYAnchor).isActive = true
            secondSkill.font = UIFont(name: "AppleSDGothicNeo-Light", size: 18)
            
            let thirdSkillContainerView = UIView()
            cell.addSubview(thirdSkillContainerView)
            thirdSkillContainerView.addSubview(thirdSkill)
            thirdSkillContainerView.translatesAutoresizingMaskIntoConstraints = false
            thirdSkillContainerView.leftAnchor.constraint(equalTo: firstSkillContainerView.leftAnchor).isActive = true
            thirdSkillContainerView.heightAnchor.constraint(equalTo: firstSkillContainerView.heightAnchor).isActive = true
            thirdSkillContainerView.topAnchor.constraint(equalTo: firstSkillContainerView.bottomAnchor, constant: 10).isActive = true
            thirdSkillContainerView.widthAnchor.constraint(equalTo: firstSkillContainerView.widthAnchor).isActive = true
            thirdSkillContainerView.layer.borderWidth = 0.5
            thirdSkillContainerView.layer.borderColor = UIColor.gray.cgColor
            thirdSkillContainerView.layer.masksToBounds = true
            
            thirdSkill.translatesAutoresizingMaskIntoConstraints = false
            thirdSkill.centerXAnchor.constraint(equalTo: thirdSkillContainerView.centerXAnchor).isActive = true
            thirdSkill.centerYAnchor.constraint(equalTo: thirdSkillContainerView.centerYAnchor).isActive = true
            thirdSkill.font = UIFont(name: "AppleSDGothicNeo-Light", size: 18)
            
            
            let fourthSkillContainerView = UIView()
            cell.addSubview(fourthSkillContainerView)
            fourthSkillContainerView.addSubview(fourthSkill)
            
            fourthSkillContainerView.addSubview(fourthSkill)
            fourthSkillContainerView.translatesAutoresizingMaskIntoConstraints = false
            fourthSkillContainerView.topAnchor.constraint(equalTo: thirdSkillContainerView.topAnchor).isActive = true
            fourthSkillContainerView.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: (skillLabelWidth - cell.bounds.width) / 6).isActive = true
            fourthSkillContainerView.widthAnchor.constraint(equalTo: firstSkillContainerView.widthAnchor).isActive = true
            fourthSkillContainerView.heightAnchor.constraint(equalTo: firstSkillContainerView.heightAnchor).isActive = true
            fourthSkillContainerView.layer.borderWidth = 0.5
            fourthSkillContainerView.layer.borderColor = UIColor.gray.cgColor
            fourthSkillContainerView.layer.masksToBounds = true
            
            
            fourthSkill.translatesAutoresizingMaskIntoConstraints = false
            fourthSkill.centerXAnchor.constraint(equalTo: fourthSkillContainerView.centerXAnchor).isActive = true
            fourthSkill.centerYAnchor.constraint(equalTo: fourthSkillContainerView.centerYAnchor).isActive = true
            fourthSkill.topAnchor.constraint(equalTo: thirdSkill.topAnchor).isActive = true
            fourthSkill.font = UIFont(name: "AppleSDGothicNeo-Light", size: 18)
            
            break
        case 3:
            let firstVideoLabel = UILabel()
            cell.addSubview(firstVideoLabel)
            firstVideoLabel.translatesAutoresizingMaskIntoConstraints = false
            firstVideoLabel.text = "Main Video"
            firstVideoLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 24)
            firstVideoLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            firstVideoLabel.topAnchor.constraint(equalTo: cell.topAnchor, constant: 10).isActive = true
            
            
            
            cell.addSubview(firstVideoImageView)
            firstVideoImageView.translatesAutoresizingMaskIntoConstraints = false
            firstVideoImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
            firstVideoImageView.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            firstVideoImageView.widthAnchor.constraint(equalToConstant: cell.bounds.width).isActive = true
            firstVideoImageView.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            firstVideoImageView.layer.borderWidth = 0.5
            firstVideoImageView.isUserInteractionEnabled = true
            
           
            if (firstVideoURl == "AddIcon") {
                firstVideoImageView.image = UIImage(named: "VideoUnavailable")
            } else {
                var firstVideoButton = playButton()
                firstVideoButton.playerURL = firstVideoURl
                cell.addSubview(firstVideoButton)
                firstVideoButton.translatesAutoresizingMaskIntoConstraints = false
                firstVideoButton.centerXAnchor.constraint(equalTo: firstVideoImageView.centerXAnchor).isActive = true
                firstVideoButton.centerYAnchor.constraint(equalTo: firstVideoImageView.centerYAnchor).isActive = true
                firstVideoButton.setBackgroundImage(UIImage(named: "playIcon"), for: .normal)
                firstVideoButton.addTarget(self, action: #selector(MoveToVideo), for: .touchUpInside)
                firstVideoButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
                firstVideoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
                
            }
            break
        case 4:
            
            let supplementalVideoLabel = UILabel()
            cell.addSubview(supplementalVideoLabel)
            supplementalVideoLabel.translatesAutoresizingMaskIntoConstraints = false
            supplementalVideoLabel.text = "Supplemental Videos"
            supplementalVideoLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 24)
            supplementalVideoLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            supplementalVideoLabel.topAnchor.constraint(equalTo: cell.topAnchor, constant: 10).isActive = true
            
            
            
            
            var supplementalPlayButton = playButton()
            cell.addSubview(supplementalImageView)
            if (supplementalVideoURL == "AddIcon") {
                supplementalImageView.image = UIImage(named: "VideoUnavailable")
            } else {
                supplementalPlayButton.playerURL = supplementalVideoURL
                supplementalImageView.addSubview(supplementalPlayButton)
                supplementalPlayButton.translatesAutoresizingMaskIntoConstraints = false
                supplementalPlayButton.centerXAnchor.constraint(equalTo: supplementalImageView.centerXAnchor).isActive = true
                supplementalPlayButton.centerYAnchor.constraint(equalTo: supplementalImageView.centerYAnchor).isActive = true
                supplementalPlayButton.addTarget(self, action: #selector(MoveToVideo), for: .touchUpInside)
                supplementalPlayButton.setBackgroundImage(UIImage(named: "playIcon"), for: .normal)
                supplementalPlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
                supplementalPlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
                
            }
            supplementalImageView.translatesAutoresizingMaskIntoConstraints = false
            supplementalImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
            supplementalImageView.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            supplementalImageView.widthAnchor.constraint(equalToConstant: cell.bounds.width).isActive = true
            supplementalImageView.topAnchor.constraint(equalTo: supplementalVideoLabel.bottomAnchor, constant: 75).isActive = true
            supplementalImageView.layer.borderWidth = 0.5
            supplementalImageView.isUserInteractionEnabled = true
            
            cell.addSubview(supplementalImageView2)
            var supplementalPlayButton2 = playButton()
            if (supplementalVideoURL2 == "AddIcon") {
                supplementalImageView2.image = UIImage(named: "VideoUnavailable")
            } else {
                supplementalPlayButton2.playerURL = supplementalVideoURL2
                supplementalImageView2.addSubview(supplementalPlayButton2)
                supplementalPlayButton2.translatesAutoresizingMaskIntoConstraints = false
                supplementalPlayButton2.centerXAnchor.constraint(equalTo: supplementalImageView2.centerXAnchor).isActive = true
                supplementalPlayButton2.centerYAnchor.constraint(equalTo: supplementalImageView2.centerYAnchor).isActive = true
                supplementalPlayButton2.addTarget(self, action: #selector(MoveToVideo), for: .touchUpInside)
                supplementalPlayButton2.setBackgroundImage(UIImage(named: "playIcon"), for: .normal)
                supplementalPlayButton2.widthAnchor.constraint(equalToConstant: 50).isActive = true
                supplementalPlayButton2.heightAnchor.constraint(equalToConstant: 50).isActive = true
            }
            supplementalImageView2.translatesAutoresizingMaskIntoConstraints = false
            supplementalImageView2.heightAnchor.constraint(equalToConstant: height).isActive = true
            supplementalImageView2.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            supplementalImageView2.widthAnchor.constraint(equalToConstant: cell.bounds.width).isActive = true
            supplementalImageView2.topAnchor.constraint(equalTo: supplementalImageView.bottomAnchor, constant: 75).isActive = true
            supplementalImageView2.layer.borderWidth = 0.5
            supplementalImageView2.isUserInteractionEnabled = true
            
            
            
            
            cell.addSubview(supplementalImageView3)
            var supplementalPlayButton3 = playButton()
            if (supplementalVideoURL3 == "AddIcon") {
                supplementalImageView3.image = UIImage(named: "VideoUnavailable")
            } else {
                supplementalPlayButton3.playerURL = supplementalVideoURL3
                supplementalImageView3.addSubview(supplementalPlayButton3)
                supplementalPlayButton3.translatesAutoresizingMaskIntoConstraints = false
                supplementalPlayButton3.centerXAnchor.constraint(equalTo: supplementalImageView3.centerXAnchor).isActive = true
                supplementalPlayButton3.centerYAnchor.constraint(equalTo: supplementalImageView3.centerYAnchor).isActive = true
                supplementalPlayButton3.addTarget(self, action: #selector(MoveToVideo), for: .touchUpInside)
                supplementalPlayButton3.setBackgroundImage(UIImage(named: "playIcon"), for: .normal)
                supplementalPlayButton3.widthAnchor.constraint(equalToConstant: 50).isActive = true
                supplementalPlayButton3.heightAnchor.constraint(equalToConstant: 50).isActive = true
                
                
            }
            supplementalImageView3.translatesAutoresizingMaskIntoConstraints = false
            supplementalImageView3.heightAnchor.constraint(equalToConstant: height).isActive = true
            supplementalImageView3.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            supplementalImageView3.widthAnchor.constraint(equalToConstant: cell.bounds.width).isActive = true
            supplementalImageView3.topAnchor.constraint(equalTo: supplementalImageView2.bottomAnchor, constant: 75).isActive = true
            supplementalImageView3.layer.borderWidth = 0.5
            supplementalImageView3.isUserInteractionEnabled = true
            
            
            
            
            
            
            
            break
            
        case 5:
            let linkedInImageView = UIImageView()
            cell.addSubview(linkedInImageView)
            linkedInImageView.translatesAutoresizingMaskIntoConstraints = false
            linkedInImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            linkedInImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            linkedInImageView.centerYAnchor.constraint(equalTo: cell.topAnchor, constant: 200 / 4 - 15).isActive = true
            linkedInImageView.image = UIImage(named: "LinkedinLogo")
            linkedInImageView.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 30).isActive = true
            
            
            cell.addSubview(linkedInTap)
            linkedInTap.translatesAutoresizingMaskIntoConstraints = false
            linkedInTap.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true 
            linkedInTap.centerYAnchor.constraint(equalTo: linkedInImageView.centerYAnchor).isActive = true
            linkedInTap.setTitle("Click Me", for: .normal)
            linkedInTap.setTitleColor(UIColor.blue, for: .normal)
            linkedInTap.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
            linkedInTap.addTarget(self, action: #selector(handleURL), for: .touchUpInside)
            
            let changeButton = UIButton()
            cell.addSubview(changeButton)
            changeButton.translatesAutoresizingMaskIntoConstraints = false
            changeButton.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            changeButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.65).isActive = true
            changeButton.topAnchor.constraint(equalTo: linkedInTap.bottomAnchor, constant: 50).isActive = true
            
            changeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            changeButton.setTitle("Add More Links", for: .normal)
            changeButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
            changeButton.setTitleColor(UIColor.white, for: .normal)
            changeButton.layer.cornerRadius = 10
            changeButton.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
            changeButton.addTarget(self, action: #selector(moveToLinks), for: .touchUpInside)
            

            
          
            
            let reminderButton = UIButton()
            reminderButton.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(reminderButton)
            reminderButton.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            reminderButton.centerYAnchor.constraint(equalTo: changeButton.centerYAnchor, constant: 200 / 4).isActive  = true
            reminderButton.widthAnchor.constraint(equalToConstant: cell.bounds.width / 2.5).isActive = true
            reminderButton.heightAnchor.constraint(equalToConstant: cell.bounds.height * 3 / 4).isActive = true
            
            reminderButton.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
            reminderButton.layer.cornerRadius = 5
            reminderButton.layer.masksToBounds = true
            reminderButton.setTitle("Add to Calendar", for: .normal)
            reminderButton.setTitleColor(UIColor.white, for: .normal)
            reminderButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
            reminderButton.addTarget(self, action: #selector(moveToSchedule), for: .touchUpInside)
        default:
            
            
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    
    
    
    //Image picker stuff
    
    
    
    
    
    //Pick the image
    
    
    
    //Place the image found in picker into the database
   
    
    
    
    
    
    
    
    
    
    
    
    
    
}
    
    
    
 


    
    
    

