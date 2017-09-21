//
//  AddLinkViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 9/12/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import UIKit
import Firebase
class AddLinkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    class Link: NSObject {
        var titleString = String()
        var urlString = String()
        
    }
    
    class linkButton: UIButton {
        var linkURL = String()
    }
    let ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("Links")
    
    var tableView = UITableView()
    func handleURL(sender: linkButton) {
        if (sender.linkURL != "") {
            openURL(url: sender.linkURL)
        } else {
            let alert = UIAlertController(title: "Failure", message: "No link available. Feel free to add one in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    func openURL(url: String) {
        let passedURL = URL(string: url)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(passedURL!, options: [:], completionHandler: nil)
            print(passedURL, "This is the passdURL")
        } else {
            UIApplication.shared.openURL(passedURL!)
            print(passedURL, "This is the passdURL")
            
        }
    }
    
    func addLink() {
        let alert = UIAlertController(title: "Add Link", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Link Title"
        })
        alert.addTextField(configurationHandler: { (textField) in
            
            textField.placeholder = "Link URL (include https://)"
            
        })
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (error) in
            print(alert.textFields?[0].text, "This is the title")
            let title = NSString(string: (alert.textFields?[0].text)!)
            let url = NSString(string: (alert.textFields?[1].text)!)
            let value = ["Link Title": title, "Link URL": url]
            self.ref.childByAutoId().setValue(value)
            let alert = UIAlertController(title: "Congratulations", message: "Link successfully set", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
     
    
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
    
    func handleBackMove() {
        dismiss(animated: true, completion: nil)
    }

    
    func fetchLinks() {
        ref.observe(.childAdded, with: { (snapshot) in
            let dictionary = snapshot.value as? [String: AnyObject]
            let link = Link()
            if (dictionary?["Link Title"] as? String != nil) {
                link.titleString = dictionary?["Link Title"] as! String
            }
            
            if (dictionary?["Link URL"] as? String != nil) {
                link.urlString = dictionary?["Link URL"] as! String
            }
            self.linkList.append(link)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        })
    }
    
    var linkList = [Link]()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLinks()

        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60).isActive = true
        tableView.separatorStyle = .none
        
        
        let backButton = UIButton()
        tableView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 10).isActive = true
        backButton.leftAnchor.constraint(equalTo: tableView.leftAnchor, constant: 10).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.setImage(UIImage(named: "arrowIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(handleBackMove), for: .touchUpInside)
        backButton.contentEdgeInsets = UIEdgeInsetsMake( -3, -3, -3, -3)

        createMastHead()

       
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return linkList.count + 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CellID")
        cell.selectionStyle = .none
        
cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        if (indexPath.row == 0) {
            var title = UILabel()
            cell.addSubview(title)
            title.translatesAutoresizingMaskIntoConstraints = false
            title.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            title.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            title.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
            title.text = "Other Links"
            
        } else if (indexPath.row == linkList.count + 1) {
            let plusIcon = UIButton()
            cell.addSubview(plusIcon)
            plusIcon.translatesAutoresizingMaskIntoConstraints = false
            plusIcon.setBackgroundImage(UIImage(named: "AddIcon"), for: .normal)
            plusIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
            plusIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
            plusIcon.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 10).isActive = true
            plusIcon.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            plusIcon.addTarget(self, action: #selector(self.addLink), for: .touchUpInside)
            
        }
        
        else {
            let link = linkList[indexPath.row - 1]
            let button = linkButton()
            
            cell.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
            button.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
            button.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            button.linkURL = link.urlString
            button.addTarget(self, action: #selector(handleURL), for: .touchUpInside)
            
            let titleLabel = UILabel()
            cell.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 15).isActive = true
            titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
            titleLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            titleLabel.text = link.titleString
            
            
            
            
        }
        
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
