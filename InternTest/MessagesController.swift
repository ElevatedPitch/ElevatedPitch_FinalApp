//
//  MessagesController.swift
//  InternTest
//
//  Created by Rahul Sheth on 2/15/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import UIKit
import Foundation
import Firebase


//This is where all of the people you can message show up. You're friends list per say. A table View with a view controller in the root view
class MessagesController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    //Initialization of variables.
    var tableView = UITableView()
    let uid = FIRAuth.auth()?.currentUser?.uid
    var userList = [User]()
    var messageList = [Messages]()
    let cellID = "cellID"
    var curName: String?
    
    //Logout button takes you to beginning 
    func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let segueController = LandingPageViewController()
        present(segueController, animated: true, completion: nil)
    }
    //Go back to the profile page
    func handlePrevious() {
        let segueController = ProfilePageViewController()
        present(segueController, animated: true, completion: nil)
        
    }
    
    
    
    //Fetch Current name
    
    func fetchName() {
        let ref = FIRDatabase.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
            let dictionary = snapshot.value as? [String: AnyObject]
            if (dictionary?["name"] != nil) {
                self.curName = dictionary?["name"] as! String?
            }
        })
    }
    
    func handleNotifications() {
        let segueController = NotificationCenterViewController()
        present(segueController, animated: false, completion: nil)
    }
    //Go to search
    func handleMoveToSearch() {
        let segueController = SearchViewController(nibName: nil, bundle: nil)
        segueController.previousController = MessagesController()
        present(segueController, animated: false, completion: nil)
    }
    func moveToProfile(sender: UIButton) {
        
        let segueController = ProfilePageViewController()
        present(segueController, animated: false, completion: nil)
    }
    func handleMoveToFeed() {
        let segueController = FeedController()
        present(segueController, animated: false, completion: nil)
        
    }
    func handleMoveToRecruiter() {
        if (globalFeedString == "Student") {
            
            let segueController = CalendarViewController()
            present(segueController, animated: false, completion: nil)
        } else {
            let segueController = SetUpFreeTimeViewController()
            present(segueController, animated: false, completion: nil)
        }

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
        let messageImage = UIImage(named: "MessageIcon-1")
        let messageTinted = messageImage?.withRenderingMode(.alwaysTemplate)
        messageIcon.setBackgroundImage(messageTinted, for: .normal)
        messageIcon.tintColor = UIColor(red: 100/255, green: 149/255, blue: 245/255, alpha: 1)
        
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
    
    

    //What runs when the view pops up
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchName()
        
        fetchMessengerUsers()
        
//       //Create a navigation bar (not preferred style tho. Better if you just adjust the bounds of your table View to include portions of the view controller
//        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height:44)) // Offset by 20 pixels vertically to take the status bar into account
//        
//        navigationBar.backgroundColor = UIColor.white
//        
//        
//        // Create a navigation item with a title
//        let navigationItem = UINavigationItem()
//        
//        // Create left and right button for navigation item
//        let leftButton =  UIBarButtonItem(title: "Logout", style:   .plain, target: self, action: #selector(handleLogout))
//        let rightButton = UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(handlePrevious))
//        
//        // Create two buttons for the navigation item
//        navigationItem.leftBarButtonItem = leftButton
//        navigationItem.rightBarButtonItem = rightButton
//        // Assign the navigation item to the navigation bar
//        navigationBar.items = [navigationItem]
//        
//        // Make the navigation bar a subview of the current view controller
//        self.view.addSubview(navigationBar)
//        
//        
        
        
        
        
        //Table View boiler plate code. Write this whenever you need a table View and have delegate and data source
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        
        createMastHead()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Move to messages and make sure the back button works
    func HandleSendToMessages(sender: AnyObject? ) {
        let time = NSNumber(value: (sender?.user.timeStamp)!)
        let updateValue = ["Last Message": sender!.user.lastMessage as AnyObject, "Sending Name": sender!.user.lastSender as AnyObject, "Read": "True" as AnyObject, "timeStamp": time] as [String : AnyObject]
        
        let ref3 = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("friends").child((sender!.user.uid))
        let ref4 = FIRDatabase.database().reference().child("users").child((sender!.user.uid)).child("friends").child((FIRAuth.auth()?.currentUser?.uid)!)
        ref3.setValue(updateValue)
        ref4.setValue(updateValue)
        sender?.user.previousController = MessagesController()
        let segueController = ChatController(user: (sender?.user)! )
        present(segueController, animated: true, completion: nil)
        
    }
    //Cell button with user information to make sure we can put the name and profile picture
    class GenericCellButton: UIButton {
        var user = User()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count + 1
    }

     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 50
        default:
            return 75
        }
    }
    

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (indexPath.row == 0) {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CellID2")
            let messagesLabel = UILabel()
            cell.addSubview(messagesLabel)
            messagesLabel.translatesAutoresizingMaskIntoConstraints = false
            messagesLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            messagesLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            messagesLabel.text = "My Messages"
            messagesLabel.font = UIFont(name: "AppleSDGothicNeo", size: 20)
            cell.selectionStyle = .none
            return cell
        } else {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        let cellLabel = UILabel()
        let cellImageView = UIImageView()
        let cellButton = GenericCellButton()
        let lastMessage = UILabel()
        

        cell.addSubview(cellButton)
        cell.addSubview(cellLabel)
        cell.addSubview(cellImageView)
        cell.addSubview(lastMessage)
        
        //This is the profilePicture image view 
            if (userList.count != 0) {
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        cellImageView.centerXAnchor.constraint(equalTo: cell.leftAnchor, constant: 40).isActive = true
        cellImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cellImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cellImageView.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        
        cellImageView.image = userList[indexPath.row - 1].imageView?.image
        cellImageView.layer.cornerRadius = 20
        cellImageView.layer.masksToBounds = true

        //This is the name of the user 
        
        cellLabel.text = userList[indexPath.row - 1].name
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        cellLabel.topAnchor.constraint(equalTo: cellImageView.topAnchor).isActive = true
        cellLabel.leftAnchor.constraint(equalTo: cellImageView.rightAnchor, constant: 10).isActive = true
        cellLabel.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        
        //The cell button takes you to the messages with the current users.
        cellButton.user = userList[indexPath.row - 1]
        cellButton.setTitle("Message", for: .normal)
        cellButton.translatesAutoresizingMaskIntoConstraints = false
        cellButton.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        cellButton.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
        cellButton.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        cellButton.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        cellButton.backgroundColor = UIColor.clear
        cellButton.layer.cornerRadius = 5
        cellButton.layer.masksToBounds = true
        cellButton.addTarget(self, action: #selector(HandleSendToMessages), for: .touchUpInside)
        
        
        lastMessage.translatesAutoresizingMaskIntoConstraints = false
        lastMessage.text = userList[indexPath.row - 1].lastMessage
        lastMessage.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        lastMessage.widthAnchor.constraint(equalToConstant: cell.bounds.width * 0.7).isActive = true
        lastMessage.leftAnchor.constraint(equalTo: cellLabel.leftAnchor).isActive = true
        lastMessage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        lastMessage.textColor = UIColor.black
        

                if (userList[indexPath.row - 1].read) {
                    cellLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
                    lastMessage.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 16)

                } else {
                    cellLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
                    lastMessage.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
                }
        // Configure the cell...
            }
        return cell
        }
    }
    
   
        
    //This finds all of your friends for the tableView 
    func fetchMessengerUsers() {
        let ref = FIRDatabase.database().reference().child("users")
        let childRef = ref.child(uid!).child("friends")
        
        ref.observe(.childAdded, with:  { (snapshot) in
            childRef.observe(.value, with: { (snapshot2) in
                for rest in snapshot2.children.allObjects as! [FIRDataSnapshot] {
                    if (snapshot.key == rest.key) {
                        
                    
                    let dictionary = snapshot2.childSnapshot(forPath: snapshot.key).value as! [String: AnyObject]
                    
                        
                    let user = User()
                        if (dictionary["Last Message"] as? String != nil) {
                    user.lastMessage = dictionary["Last Message"] as! String
                    user.lastSender = dictionary["Sending Name"] as! String
                            if (dictionary["timeStamp"] as? Double != nil) {
                                user.timeStamp = dictionary["timeStamp"] as! Double
                            }
                            if (dictionary["Read"] as? String == "False" && dictionary["Sending Name"] as? String != self.uid) {
                                user.read = false
                            }
                        }
                    user.uid = snapshot.key
                        let dictionary2 = snapshot.value as! [String:AnyObject]
                        
                        if (dictionary2["name"] != nil) {
                            user.name = dictionary2["name"] as! String
                            
                            
                        }
                        if (dictionary2["profileImageURL"] as? String != nil) {
                        let profileImageURL = dictionary2["profileImageURL"] as! String
                        user.imageView?.loadImageUsingCacheWithURLString(urlString: profileImageURL)
                        }
                        
                        
                        self.userList.append(user)
                        self.userList.sort(by:  ({$0.timeStamp < $1.timeStamp}))


                    }
                    DispatchQueue.main.async {

                        self.tableView.reloadData()
                        
                        }
                    
                 

                    
                    
                    }
                
                
                
                
        
            
            
            
                })
            
            })
        
        
    }
}
