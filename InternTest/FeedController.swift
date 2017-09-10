//
//  FeedController.swift
//  InternTest
//
//  Created by Rahul Sheth on 1/16/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation
import Firebase


//The full user feed 
var globalFeedString = String()
var globalCurrentName = String()
var globalProfilePictureImageURL = String()
class FeedController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //Initialization of variables
    let uid = FIRAuth.auth()?.currentUser?.uid
    var tableView = UITableView()
  var ref = FIRDatabase.database().reference()
    var userList = [User]()
    let cellID = "cellID"
    var profileImageURL: String?
    var passedInString: String?
    var passedInInt: Int?
    var refreshControl: UIRefreshControl!
    var searchBool: Bool?
    var previousController: UIViewController?

    
    deinit {
        
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    //--------------------------------------------------------------------------------
    
    
    //HELPER FUNCTIONS  and Buttons
    
    class GenericCellButton: UIButton  {
        var user = User()
    }
    
    
    class NoButton: UIButton {
        var value = Int()
    }
    
    
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    //Call this so you can load up your messenger users before you start up
    
    
    func fetchMessengerUsers() {
        let ref = FIRDatabase.database().reference().child("users")
        let childRef = ref.child(uid!).child("friends")
        
        ref.observe(.childAdded, with:  { (snapshot) in
            childRef.observe(.value, with: { (snapshot2) in
                for rest in snapshot2.children.allObjects as! [FIRDataSnapshot] {
                    if (snapshot.key == rest.key as! String) {
                        
                        
                        let user = User()
                        user.uid = snapshot.key
                        let dictionary2 = snapshot.value as! [String:AnyObject]
                        
                        
                        if (dictionary2["profileImageURL"] as? String != nil) {
                            let profileImageURL = dictionary2["profileImageURL"] as! String
                            let imageView = UIImageView()
                            imageView.loadIntoCache(urlString: profileImageURL)
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
            })
            
        })
        
    }

    
    
    //Move to your Calendar with the reminders
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

    
    
    
    //Get your personal Profile Image. This is useful for displaying your profile Picture in notifications
    func getProfileImageURL() {
        
        
        ref.child("users").child(uid!).observe(.value, with: { (snapshot) in
            
            if (snapshot.value as! [String: AnyObject] != nil) {
            let dictionary = snapshot.value as! [String: AnyObject]
            
            if (dictionary["profileImageURL"] as? String != nil) {
                globalProfilePictureImageURL = (dictionary["profileImageURL"] as! String?)!

            }
            }
            
            
        })
    }
    
    
    
    //Move back to your profile
   
    
    //When you press Yes, this is what happens. Registers as friend, uploads Notification and moves to their view controller 
    func handleYesButton(sender: AnyObject? ) {
        let childRef = ref.child("users").child(uid!).child("friends").child((sender?.user.uid)!)
        let values = ["Friends?": "Yes"]
        childRef.updateChildValues(values)
        
        let otherRef = ref.child("users").child((sender?.user.uid)!).child("friends").child(uid!)
        otherRef.updateChildValues(values)
        
        let userReference = ref.child("users").child((sender?.user.uid)!).child("Notifications").childByAutoId()
        
        
        var updateString = globalCurrentName
        updateString.append(" wants to be connect")
        let realUpdate = NSString(string: updateString)
        let updateUID = NSString(string: uid!)
        
        let url = NSString(string: (globalProfilePictureImageURL))
        
        let readString = "false" as NSString
        var positionString = NSString()
        
        if (globalFeedString == "Student") {
            positionString = NSString(string: "Employer")
        } else {
            positionString = NSString(string: "Student")
        }
        let value = ["Message": realUpdate, "Type": "Friend", "OtherUID": updateUID, "profileImageURL": url, "read": readString, "Occupation": positionString]
        
        userReference.updateChildValues(value)
        
        if (sender?.user.occupation == "Employer") {
            let segueController = EmployerViewController(nibName: nil, bundle: nil)
            segueController.user = (sender?.user)!
            present(segueController, animated: true, completion: nil)
        } else {
            let segueController = StudentViewController(user: (sender?.user)!)
            present(segueController, animated: true, completion: nil)
        }
        
        
        
        
    }
    
    //When you press no, it moves to the next person
    func handleNoButton(sender: AnyObject? ) {
        if ((sender?.value)! + 1 < userList.count) {
            let indexPath = NSIndexPath(row: (sender?.value)! + 1, section: 0)
            tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
            
        } else {
            let indexPath = NSIndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
            
        }
        
        
    }
    
   //When you press play, this is what's called
    
    func handleVideo(sender: GenericCellButton) {
        
        let url = URL(string: sender.user.videoURL)
        
        
        
        if (url != nil) {
            let player = AVPlayer(url: (url! as URL))
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true, completion: {
                playerViewController.player?.play()
            })
        } else {
            let alert = UIAlertController(title: "Failure", message: "No Video Available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        
    }

    
    
    func fetchUsers() {
        self.userList.removeAll()
        var checkBool = true
        
        var recruiterOrAll = true
        ref.child("users").observe(.childAdded, with: {  (snapshot) in
            

                if let dictionary = snapshot.value as? [String: AnyObject] {
                    if (self.searchBool == nil) {
                        self.searchBool = false
                    }
                    switch self.searchBool! {
                    case false:
                        if ((dictionary["Occupation"] as? String) != globalFeedString) {
                            recruiterOrAll = false
                            
                            break
                            
                        }
                        else {
                            recruiterOrAll = true
                            
                        }
                    default:
                        recruiterOrAll = true
                        break
                    }
                    if (recruiterOrAll) {
                        if (self.passedInInt == nil) {
                            self.passedInInt = 5
                        }
                        switch self.passedInInt! {
                        case 0:
                            if (dictionary["Major"] as? String != self.passedInString!) {
                                checkBool = false
                                break
                            }
                            checkBool = true
                            break
                        case 1:
                            if (dictionary["Unversity"] as? String != self.passedInString!) {
                                checkBool = false
                                
                                break
                            }
                            checkBool = true
                            break
                            
                            
                        case 2:
                            if (dictionary["Company"] as? String != self.passedInString!) {
                                checkBool = false
                                
                                break
                            }
                            checkBool = true
                            break
                            
                            
                        case 3:
                            if (snapshot.key != self.passedInString!) {
                                
                                checkBool = false
                                break
                            }
                            checkBool = true
                            break
                        case 4:
                            if (dictionary["Skill 1"] as? String != self.passedInString! && dictionary["Skill 2"] as? String != self.passedInString! && dictionary["Skill 3"] as? String != self.passedInString! && dictionary["Skill 4"] as? String != self.passedInString) {
                                checkBool = false
                                break
                                
                            }
                            checkBool = true
                            break
                        default:
                            checkBool = true
                            break
                            
                        }
                        if (checkBool) {
                            
                            let user = User()
                            if ((dictionary["name"] as? String) != nil) {
                                user.name = (dictionary["name"] as? String)!
                            } else {
                                user.name = "Placeholder"
                            }
                            if ((dictionary["userVideoURL"] as? String) != nil) {
                                
                                user.videoURL = dictionary["userVideoURL"] as! String
                            }
                            user.uid = snapshot.key
                            if ((dictionary["Occupation"] as? String) != nil) {
                                user.occupation = (dictionary["Occupation"] as? String)!
                                user.companyLabel = (dictionary["Occupation"] as? String)!
                                if (user.occupation == "Employer" && dictionary["Company"] as? String != nil) {
                                    user.companyLabel = (dictionary["Company"] as? String)!
                                } else if (user.occupation == "Student" && dictionary["University"] as? String != nil) {
                                    user.companyLabel = (dictionary["University"] as? String)!
                                }
                            }
                            
                            if (dictionary["thumbnailImageURL"] as! String?) != nil {
                                user.thumbnailImageURL = (dictionary["thumbnailImageURL"] as! String?)!
                                
                                
                                
                            }
                            if ((dictionary["profileImageURL"] as! String?) != nil) {
                                user.profileImageURL = (dictionary["profileImageURL"] as! String?)!
                            } else {
                                user.profileImageURL = "NIL"
                            }
                            self.userList.append(user)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                
                            }
                            
                        }
                    }
                    
                }
            
        })
        refreshControl.endRefreshing()
//        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
    }
    
    
    
    func createMastHead() {
        
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
        searchIcon.addTarget(self, action: #selector(handleMoveToSearch), for: .touchUpInside)
        let searchImage = UIImage(named: "searchIcon")
        let searchTinted = searchImage?.withRenderingMode(.alwaysTemplate)
        searchIcon.setBackgroundImage(searchTinted, for: .normal)
        searchIcon.tintColor = UIColor.white
        
        searchIcon.centerXAnchor.constraint(equalTo: self.view.leftAnchor, constant: (self.view.bounds.width / 2 - titleLabel.intrinsicContentSize.width / 2) / 2).isActive = true
        searchIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        let notificationIcon = UIButton()
        self.view.addSubview(notificationIcon)
        notificationIcon.translatesAutoresizingMaskIntoConstraints = false
        notificationIcon.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        notificationIcon.topAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        notificationIcon.centerXAnchor.constraint(equalTo: self.view.rightAnchor, constant: (titleLabel.intrinsicContentSize.width / 2 - self.view.bounds.width / 2) / 2).isActive = true
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
        let feedTinted = feedImage?.withRenderingMode(.alwaysTemplate)
        feedIcon.setBackgroundImage(feedTinted, for: .normal)
        feedIcon.tintColor = UIColor(red: 100/255, green: 149/255, blue: 245/255, alpha: 1)

        
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


    
    
    //ViewDid Load 
    
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: (0/255.0), green: (204/255.0), blue: (255/255.0), alpha: 1)
        
        
        getProfileImageURL()
        
        fetchMessengerUsers()
        
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with:
            { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]  {
                    if (dictionary["name"] as? String != nil) {
                    globalCurrentName = (dictionary["name"] as? String)!

                    }
                    if ((dictionary["Occupation"] as? String) == "Employer") {
                        globalFeedString = "Student"
                        
                    }
                    else {
                        globalFeedString = "Employer"
                    }
                }
        })
        self.view.addSubview(tableView)
        
        
        
        //Refresh and fetch more users. 
        
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(fetchUsers), for: UIControlEvents.valueChanged)
        fetchUsers()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60).isActive = true
        tableView.separatorStyle = .none
        
        
        
        
        let ProfileButton = UIButton()
        let MessageButton = UIButton()
        let LogoutButton = UIButton()
       
        let profileText = UILabel()
        let messageText = UILabel()
        let logoutText = UILabel()
        
        self.view.addSubview(ProfileButton)
        self.view.addSubview(MessageButton)
        self.view.addSubview(LogoutButton)
        self.view.addSubview(profileText)
        self.view.addSubview(messageText)
        self.view.addSubview(logoutText)
        
        
        MessageButton.setImage(UIImage(named: "Chat"), for: .normal)
        LogoutButton.setImage(UIImage(named: "images"), for: .normal)
        ProfileButton.setImage(UIImage(named: "ProfileImage"), for: .normal)
        
        MessageButton.setTitle("Chat", for: .normal)
        LogoutButton.setTitle("Logout", for: .normal)
        ProfileButton.setTitle("Profile", for: .normal)
        
        
        LogoutButton.translatesAutoresizingMaskIntoConstraints = false
        LogoutButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        LogoutButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        LogoutButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        LogoutButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -13).isActive = true
        LogoutButton.tintColor = UIColor.clear
        LogoutButton.contentEdgeInsets = UIEdgeInsetsMake( 10, 10, 10, 10)
        LogoutButton.transform = LogoutButton.transform.rotated(by: CGFloat(M_PI))
        LogoutButton.addTarget(self, action: #selector(handleMoveToRecruiter), for: .touchUpInside)
        
        ProfileButton.translatesAutoresizingMaskIntoConstraints = false
        ProfileButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        ProfileButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        ProfileButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        ProfileButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        ProfileButton.tintColor = UIColor.clear
        ProfileButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        ProfileButton.addTarget(self, action: #selector(moveToProfile), for: .touchUpInside)
        
        profileText.translatesAutoresizingMaskIntoConstraints = false
        profileText.text = "Profile"
        profileText.font = UIFont(name: "Didot", size: 10)
        profileText.textColor = UIColor.black
        profileText.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -7).isActive = true
        profileText.widthAnchor.constraint(equalTo: ProfileButton.widthAnchor).isActive = true
        profileText.heightAnchor.constraint(equalToConstant: 10).isActive = true
        profileText.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 25).isActive = true
        
      
        MessageButton.translatesAutoresizingMaskIntoConstraints = false
        MessageButton.bottomAnchor.constraint(equalTo: ProfileButton.bottomAnchor).isActive = true
        MessageButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        MessageButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        MessageButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -35).isActive = true
        
        MessageButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        
        
        createMastHead()

        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        
        view.addGestureRecognizer(tap)
        
    }
    class Cell: UITableViewCell {
        var cellButton = UIButton()
        var cellLabel = UILabel()
        
    }
    
    
    
    
    //-------------------------------------------------------------------------------------------------------
    
      

    
    //SET UP YOUR TABLE VIEW 
    
    
    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let border = CALayer()
        let borderWidth = CGFloat(5.0)
        border.borderColor = UIColor.lightGray.cgColor
        let height = 0.75 * (view.frame.size.height - 120)
        border.frame = CGRect(x: 0, y: height - borderWidth, width:  view.frame.size.width , height: height)
        
        border.borderWidth = borderWidth
        let cell = FeedTableViewCell(style: .subtitle, reuseIdentifier: cellID)
        cell.selectionStyle = .none
        let cellWidth = cell.bounds.width
        cell.layer.addSublayer(border)
        cell.layer.masksToBounds = true
        let curUser = userList[indexPath.row] as User
        cell.activityIndicator = UIActivityIndicatorView()
        cell.object = curUser
        let cellLabel = UILabel()
        cell.addSubview(cellLabel)
        let width  = self.view.bounds.width - 40
        let cellButton = GenericCellButton()
        cell.addSubview(cellButton)
        let cellNoButton = NoButton()
        cell.addSubview(cellNoButton)
        cell.addSubview((cell.object?.imageView)!)
        let cellCheckButton = GenericCellButton()
        cell.addSubview(cellCheckButton)
        
        
        let cellImageView = UIImageView()
        cell.addSubview(cellImageView)
        cellImageView.loadImageUsingCacheWithURLString(urlString: curUser.profileImageURL)
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        cellImageView.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 30).isActive = true
        cellImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        cellImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        cellImageView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 30).isActive = true
        cellImageView.layer.borderWidth = 1
        cellImageView.layer.borderColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1).cgColor
        cellImageView.layer.cornerRadius = 17.5
        cellImageView.layer.masksToBounds = true
        cellNoButton.value = indexPath.row
        cellNoButton.setBackgroundImage(UIImage(named: "checkNoIcon"), for: .normal)
        cellNoButton.alpha = 0.3
        cellNoButton.addTarget(self, action: #selector(handleNoButton), for: .touchUpInside)
        cellNoButton.translatesAutoresizingMaskIntoConstraints = false
        cellNoButton.bottomAnchor.constraint(equalTo: cellButton.bottomAnchor).isActive = true
        cellNoButton.widthAnchor.constraint(equalToConstant: width / 8).isActive = true
        cellNoButton.heightAnchor.constraint(equalToConstant: width / 8).isActive = true
        cellNoButton.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: width / 6).isActive = true
        cellNoButton.isUserInteractionEnabled = true

        
        
        cellNoButton.backgroundColor = UIColor.white
        cellNoButton.setTitleColor(UIColor.black, for: .normal)
        
        cellCheckButton.user = userList[indexPath.row]
        
        cellCheckButton.translatesAutoresizingMaskIntoConstraints = false
        cellCheckButton.setBackgroundImage(UIImage(named: "playIcon"), for: .normal)
        cellCheckButton.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -15).isActive = true
        cellCheckButton.widthAnchor.constraint(equalToConstant: width / 4).isActive = true
        cellCheckButton.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        cellCheckButton.isUserInteractionEnabled = true
        cellCheckButton.setTitleColor(UIColor.black, for: .normal)
        cellCheckButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        cellCheckButton.addTarget(self, action: #selector(handleVideo), for: .touchUpInside)
        cellCheckButton.alpha = 0.3
       

        cellButton.backgroundColor = UIColor.white
        cellButton.translatesAutoresizingMaskIntoConstraints = false
        cellButton.setBackgroundImage(UIImage(named: "CheckYesIcon"), for: .normal)
        cellButton.bottomAnchor.constraint(equalTo: cellCheckButton.bottomAnchor, constant: -15).isActive = true
        cellButton.heightAnchor.constraint(equalTo: cellNoButton.widthAnchor).isActive = true
        cellButton.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -1 * width / 6 ).isActive = true
        cellButton.isUserInteractionEnabled = true
        cellButton.user = userList[indexPath.row]
        cellButton.addTarget(self, action: #selector(handleYesButton), for: .touchUpInside)
        cellButton.widthAnchor.constraint(equalTo: cellNoButton.widthAnchor).isActive = true
        cellButton.alpha = 0.3
        
        cell.object?.imageView?.loadImageUsingCacheWithURLString(urlString: curUser.thumbnailImageURL)
        cell.object?.imageView?.translatesAutoresizingMaskIntoConstraints = false
        cell.object?.imageView?.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
        cell.object?.imageView?.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 4).isActive = true
        cell.object?.imageView?.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        cell.object?.imageView?.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        
        
        

        cell.addSubview(cell.activityIndicator)
        cell.activityIndicator.color = UIColor.gray
        cell.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        cell.activityIndicator.leftAnchor.constraint(equalTo: (cell.object?.imageView?.leftAnchor)!).isActive = true
        cell.activityIndicator.rightAnchor.constraint(equalTo: (cell.object?.imageView?.rightAnchor)!).isActive = true
        cell.activityIndicator.topAnchor.constraint(equalTo: (cell.object?.imageView?.topAnchor)!).isActive = true
        cell.activityIndicator.bottomAnchor.constraint(equalTo: (cell.object?.imageView?.bottomAnchor)!).isActive = true
        
       
       
        

        let cellLabelOccupation = UILabel()
        cell.addSubview(cellLabelOccupation)
        cellLabelOccupation.text = userList[indexPath.row].companyLabel
        cellLabelOccupation.translatesAutoresizingMaskIntoConstraints = false
        cellLabelOccupation.leftAnchor.constraint(equalTo: cellImageView.rightAnchor, constant: 5).isActive = true
        cellLabelOccupation.rightAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        cellLabelOccupation.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: 5).isActive = true
        cellLabelOccupation.font = UIFont(name: "AppleSDGothicNeo", size: 4)
        
        
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        cellLabel.bottomAnchor.constraint(equalTo: cellLabelOccupation.topAnchor, constant: 2).isActive = true
        cellLabel.leftAnchor.constraint(equalTo: cellLabelOccupation.leftAnchor).isActive = true
        cellLabel.text = userList[indexPath.row].name
        cellLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        
      
        
        
        
        
        
      
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let height = view.frame.size.height - 120
        
        return 0.75 * height
    }


}



