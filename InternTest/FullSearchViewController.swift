//
//  FullSearchViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 7/12/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FullSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    //INITIALIZATION OF VARIABLES
    
    var itemList = [AnyObject]()
    var tableView = UITableView()
    var isItemAUser: Bool?
    var typeInt: Int?
    
    
    class genericCellButton: UIButton {
        var passedString: String?
        
    }
    
    
    //-------------------------------------------------------------------------------------------
    //HELPER FUNCTIONS AND VIEW DID LOAD 
    
    //Move back to Feed with the value you want
    func handleMoveToFeed(sender: genericCellButton) {
        let segueController = FeedController(nibName: nil, bundle: nil)
        segueController.passedInInt = typeInt
        segueController.passedInString = sender.passedString
        segueController.searchBool = true
        present(segueController, animated: true, completion: nil)
    }
    
    //Move to your Calendar with the reminders
    func MoveToFeed() {
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
    func handleCalendar() {
        
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
        searchIcon.tintColor = UIColor.gray
        
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
        feedIcon.addTarget(self, action: #selector(MoveToFeed), for: .touchUpInside)
        
        let calendarIcon = UIButton()
        self.view.addSubview(calendarIcon)
        calendarIcon.translatesAutoresizingMaskIntoConstraints = false
        calendarIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        calendarIcon.widthAnchor.constraint(equalToConstant: width / 1.5).isActive = true
        calendarIcon.centerXAnchor.constraint(equalTo: self.view.leftAnchor, constant: 3 * width).isActive = true
        calendarIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        let calendarPic = UIImage(named: "CalendarIcon")
        let calendarTinted = calendarPic?.withRenderingMode(.alwaysTemplate)
        calendarIcon.setBackgroundImage(calendarPic, for: .normal)
        calendarIcon.tintColor = UIColor(red: 100/255, green: 149/255, blue: 245/255, alpha: 1)
        calendarIcon.addTarget(self, action: #selector(handleCalendar), for: .touchUpInside)
        
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

    //View Did load
    override func viewDidLoad() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60).isActive = true
        tableView.separatorStyle = .none
        
        createMastHead()

    }
    
    
    //-------------------------------------------------------------------------------------------

    
    //SET UP TABLE VIEW
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CellID")
        
        
        let textLabel = UILabel()
        cell.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        if (isItemAUser)! {
            let user = itemList[indexPath.row] as? User
        textLabel.text = user?.name

        }
        else {
            textLabel.text = itemList[indexPath.row] as? String
        }
        
        
        textLabel.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 15).isActive = true
        textLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        textLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        
        let cellButton = genericCellButton()
        cellButton.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(cellButton)
        cellButton.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
        cellButton.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        cellButton.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        cellButton.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        if (itemList[indexPath.row] is User) {
        cellButton.passedString = itemList[indexPath.row].uid
        } else {
            cellButton.passedString = itemList[indexPath.row] as? String
        }
        cellButton.addTarget(self, action: #selector(handleMoveToFeed), for: .touchUpInside)
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    
    
    
}
