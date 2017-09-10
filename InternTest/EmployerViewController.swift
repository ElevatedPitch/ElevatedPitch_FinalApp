//
//  EmployerViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 8/30/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import UIKit
import Firebase

class EmployerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    class urlTap: UIButton {
        var urlString = String()
        
    }
    
    var tableView = UITableView()
    var profileImageView = UIImageView()
    var user = User() 
    
    
    
    //TableView SetUp
    
    
    var nameLabel = UILabel()
    var profileImageURL = String()
    let ai = UIActivityIndicatorView()
    var fullLabel = UILabel()
    var companyMission = UILabel()
    var position1 = UILabel()
    var position1Description = UILabel()
    var position2 = UILabel()
    var position2Description = UILabel()
    var position3 = UILabel()
    var position3Description = UILabel()
    var companySite = urlTap()
    
    
    
    deinit {
        profileImageView.removeObserver(self, forKeyPath: "image")
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "image") {
            ai.hidesWhenStopped = true
            ai.stopAnimating()
        }
    }
    
    func fetchDatabaseValues() {
        
        let uid = user.uid
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            
            let dictionary = snapshot.value as! [String: AnyObject]
            
            if dictionary["name"] as! String? != nil {
                self.nameLabel.text = dictionary["name"] as! String?
            } else {
                self.nameLabel.text = "Placeholder"
            }
            
            if dictionary["Company"] as! String? != nil {
                if (self.nameLabel.text != "Placeholder") {
                    self.nameLabel.text?.append(" - ")
                }
                self.nameLabel.text?.append((dictionary["Company"] as! String?)!)
                
            }
            if dictionary["profileImageURL"] as! String? != nil {
                
                self.profileImageURL = (dictionary["profileImageURL"] as! String?)!
                
                self.profileImageView.loadImageUsingCacheWithURLString(urlString: self.profileImageURL)
                
                
            } else {
                self.profileImageURL = "AddIcon"
            }
            
            if dictionary["Bio"] as? String != nil {
                self.fullLabel.text = dictionary["Bio"] as! String
            }
            
            if dictionary["Company Mission"] as? String != nil {
                self.companyMission.text = dictionary["Company Mission"] as! String
            }
            if dictionary["Position 1"] as? String != nil {
                self.position1.text = dictionary["Position 1"] as! String
                
            } else {
                self.position1.text = "No Position"
            }
            
            if dictionary["Position 1 Description"] as? String != nil {
                self.position1Description.text = dictionary["Position 1 Description"] as! String
            }
            
            if dictionary["Position 2"] as? String != nil {
                self.position2.text = dictionary["Position 2"] as! String
                
            } else {
                self.position2.text = "No Position"
            }
            if dictionary["Position 2 Description"] as? String != nil {
                self.position2Description.text = dictionary["Position 2 Description"] as! String
            }
            
            if dictionary["Position 3"] as? String != nil {
                self.position3.text = dictionary["Position 3"] as! String
            } else {
                self.position3.text = "No Position"
            }
            
            if dictionary["Position 3 Description"] as? String != nil {
                self.position3Description.text = dictionary["Position 3 Description"] as! String
            }
            
            if dictionary["Company Site"] as? String != nil {
                self.companySite.urlString = dictionary["Company Site"] as! String
            }
            
            
            
        })

    }


    func handleMoveToSearch() {
        let segueController = SearchViewController()
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
    
    func handleMoveToProfile() {
        let segueController = ProfilePageViewController()
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
    func mastheadMoveToMessages() {
        let segueController = MessagesController()
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
        calendarIcon.addTarget(self, action: #selector(handleCalendar), for: .touchUpInside)
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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        profileImageView.addObserver(self, forKeyPath: "image", options: NSKeyValueObservingOptions.new, context: nil)
        fetchDatabaseValues()
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
    
    
    func handleURL(sender: urlTap) {
        if (sender.urlString != "") {
            openURL(url: sender.urlString)
        } else {
            let alert = UIAlertController(title: "Failure", message: "No link available. Feel free to message user.", preferredStyle: .alert)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 3:
            return 60
            
        case 1, 2, 4, 5, 6:
            return 150
            
        default:
            return 80
            
        }
    }
    
    func handleMoveToMessages() {
        
        user.previousController = StudentViewController(user: user)
        let segueController = ChatController(user: user)
        present(segueController, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
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
            nameLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 20)
            
            let messageIndividualButton = UIButton()
            cell.addSubview(messageIndividualButton)
            messageIndividualButton.translatesAutoresizingMaskIntoConstraints = false
            messageIndividualButton.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -25).isActive = true
            messageIndividualButton.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            messageIndividualButton.heightAnchor.constraint(equalToConstant: cell.bounds.height * 0.7).isActive = true
            messageIndividualButton.widthAnchor.constraint(equalToConstant: cell.bounds.height * 0.8).isActive = true
            messageIndividualButton.setImage(UIImage(named: "MessageIcon-1"), for: .normal)
            messageIndividualButton.addTarget(self, action: #selector(handleMoveToMessages), for: .touchUpInside)
            
            
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
                profileImageView.image = UIImage(named: "AddIcon")
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
            
            
            let titleLabel = UILabel()
            cell.addSubview(titleLabel)
            titleLabel.text = "Company Mission"
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            titleLabel.centerYAnchor.constraint(equalTo: cell.topAnchor, constant: 20).isActive = true
            titleLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 24)
            
            cell.addSubview(companyMission)
            companyMission.translatesAutoresizingMaskIntoConstraints = false
            companyMission.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            companyMission.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 10).isActive = true
            companyMission.widthAnchor.constraint(equalToConstant: cell.bounds.width * 0.75 ).isActive = true
            companyMission.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
            companyMission.textAlignment = .center
            companyMission.numberOfLines = 0
            companyMission.lineBreakMode = .byWordWrapping
            break
            
        case 3:
            let titleLabel = UILabel()
            cell.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            titleLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            titleLabel.text = "Positions Available"
            titleLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
            
        case 4:
            
           
            
            cell.addSubview(position1)
            position1.translatesAutoresizingMaskIntoConstraints = false
            position1.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.75).isActive = true
            position1.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
            position1.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            position1.centerYAnchor.constraint(equalTo: cell.topAnchor, constant: 20).isActive = true
            position1.lineBreakMode = .byWordWrapping
            position1.numberOfLines = 0
            position1.textAlignment = .center
            cell.addSubview(position1Description)
            position1Description.translatesAutoresizingMaskIntoConstraints = false
            position1Description.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            position1Description.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 10).isActive = true
            position1Description.widthAnchor.constraint(equalToConstant: cell.bounds.width * 0.75 ).isActive = true
            position1Description.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
            position1Description.textAlignment = .center
            position1Description.numberOfLines = 0
            position1Description.lineBreakMode = .byWordWrapping
            break
            
        case 5:
          
            cell.addSubview(position2)
            position2.translatesAutoresizingMaskIntoConstraints = false
            position2.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.75).isActive = true
            position2.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
            position2.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            position2.centerYAnchor.constraint(equalTo: cell.topAnchor, constant: 20).isActive = true
            position2.lineBreakMode = .byWordWrapping
            position2.numberOfLines = 0
            position2.textAlignment = .center
            cell.addSubview(position2Description)
            position2Description.translatesAutoresizingMaskIntoConstraints = false
            position2Description.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            position2Description.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 10).isActive = true
            position2Description.widthAnchor.constraint(equalToConstant: cell.bounds.width * 0.75 ).isActive = true
            position2Description.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
            position2Description.textAlignment = .center
            position2Description.numberOfLines = 0
            position2Description.lineBreakMode = .byWordWrapping
            
            break
        case 6:
            
           
            cell.addSubview(position3)
            position3.translatesAutoresizingMaskIntoConstraints = false
            position3.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.75).isActive = true
            position3.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
            position3.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            position3.centerYAnchor.constraint(equalTo: cell.topAnchor, constant: 20).isActive = true
            position3.lineBreakMode = .byWordWrapping
            position3.numberOfLines = 0
            position3.textAlignment = .center
            cell.addSubview(position3Description)
            position3Description.translatesAutoresizingMaskIntoConstraints = false
            position3Description.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            position3Description.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 10).isActive = true
            position3Description.widthAnchor.constraint(equalToConstant: cell.bounds.width * 0.75 ).isActive = true
            position3Description.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
            position3Description.textAlignment = .center
            position3Description.numberOfLines = 0
            position3Description.lineBreakMode = .byWordWrapping
            break
            
        case 7:
            cell.addSubview(companySite)
            companySite.translatesAutoresizingMaskIntoConstraints = false
            companySite.setTitle("Company Site", for: .normal)
            companySite.setTitleColor(UIColor.blue, for: .normal)
            companySite.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            companySite.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            companySite.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
            companySite.addTarget(self, action: #selector(handleURL), for: .touchUpInside)
            break
        default:
            break
            
        }

        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
