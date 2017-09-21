//
//  ProfilePageViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 12/25/16.
//  Copyright © 2016 Rahul Sheth. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import AVFoundation

//This is where you see your profile Page
class ProfilePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    

    
    //INITIALIZATION OF VARIABLES 
    
    class urlTap: UIButton {
        var urlString = String()
        
    }
    
    let linkedInTap = urlTap()
    let githubTap = urlTap()
    let bruinTap = urlTap()
    let height = UIScreen.main.bounds.height / 4

    var tableView =  UITableView()
    class emailButton: UIButton {
        var userEmail: String = ""
    }
    var profileImageURL: String?
    let headerLabel = UILabel()
    let nameLabel = UILabel()
    let titleLabel = UILabel()
    var height2 = CGFloat()
    var width = CGFloat()
    
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

    
    
    let companyMission = UILabel()
    let position1 = UILabel()
    let position1Description = UILabel()
    let position2 = UILabel()
    let position2Description = UILabel()
    let position3 = UILabel()
    let position3Description = UILabel()
    let companySite = urlTap()
    
    
    var caption1Label = UILabel()
    var captionExperienceLabel = UILabel()
    var captionSkillsLabel = UILabel()
    var captionExtraLabel = UILabel()
    // ----------------------------------------------------------------------
    
    //HELPER FUNCTIONS AND VIEW DID LOAD 
    
    deinit {
        profileImageView.removeObserver(self, forKeyPath: "image")
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "image") {
            ai.hidesWhenStopped = true
            ai.stopAnimating()
        }
    }
    
    func handleURL(sender: urlTap) {
        if (sender.urlString != "" && sender.urlString.contains("https://")) {
      openURL(url: sender.urlString)
        } else {
            let alert = UIAlertController(title: "Failure", message: "No link available. Feel free to add one in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Upload", style: .default, handler: { (error) in
            
                let alert = UIAlertController(title: "Add in a link", message: nil, preferredStyle: .alert)
                alert.addTextField(configurationHandler: { (textField) in
                    
                    textField.placeholder = "LinkedIn Link (include https://)"
                    
                    
                })
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (error) in
                    
                    let ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
                    if (alert.textFields?[0].text! != "") {
                        let value = NSString(string: (alert.textFields?[0].text!)!)
                        let upload = ["linkedInLink": value]
                        ref.updateChildValues(upload)
                        DispatchQueue.main.async {
                            self.checkIfUserLoggedInAsStudent()
                        }
                    }
                    
                }))
                self.present(alert, animated: true, completion: nil)


            
            }))
            alert.addAction(UIAlertAction(title: "Find your profile link", style: .default, handler: { (error) in
                    self.openURL(url: "https://www.linkedin.com/help/linkedin/answer/49315/finding-your-linkedin-public-profile-url?lang=en")
                
            }))
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
    
    
    //Movement to the rest of the app
    func handleMoveToMessages() {
        let segueController = MessagesController()
        present(segueController, animated: false, completion: nil)
    }
    
    
    
    //Go to search
    func handleMoveToSearch() {
        let segueController = SearchViewController(nibName: nil, bundle: nil)
        segueController.previousController = ProfilePageViewController()
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
    
    func handleRecruiter() {
        
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
    
   
    //Logout
    func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
        }
        
        let segueController = LandingPageViewController()
        present(segueController, animated: true, completion: nil)

        }
    
    
    
    //If you're logged in, load up all of the data
    func checkIfUserLoggedInAsStudent() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
                handleLogout()
        }
        
        else {
            let uid = FIRAuth.auth()?.currentUser?.uid
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
                    if dictionary["Unversity"] as! String? != nil {
                        self.nameLabel.text?.append(" - ")
                        self.nameLabel.text?.append((dictionary["Unversity"] as! String?)!)
                    }
                   
                    

                    
                    if dictionary["profileImageURL"] as! String? != nil {
                        
                         self.profileImageURL = dictionary["profileImageURL"] as! String?
                            
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
                    if (dictionary["githubLink"] as! String? != nil) {
                        self.githubTap.urlString = (dictionary["githubLink"] as! String?)!
                    }
                    if (dictionary["bruinViewLink"] as! String? != nil) {
                        self.bruinTap.urlString = (dictionary["bruinViewLink"] as! String?)!
                    }
                    
                    
                }

                

            })

            
        
    }
    }
    
    
    func checkIfUserLoggedInAsEmployer() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            handleLogout()
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            let ref = FIRDatabase.database().reference().child("users").child(uid!)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
               
                    if dictionary["name"] as! String? != nil {
                        self.nameLabel.text = dictionary["name"] as! String?
                    } else {
                        self.nameLabel.text = "Placeholder"
                    }
                    if dictionary["firstCaption"] as? String != nil {
                        self.caption1Label.text = dictionary["firstCaption"] as? String
                    } else {
                        self.caption1Label.text = "Update Video to add a caption..."
                    }
                    if dictionary["Company"] as! String? != nil {
                        if (self.nameLabel.text != "Placeholder") {
                        self.nameLabel.text?.append(" - ")
                        }
                        self.nameLabel.text?.append((dictionary["Company"] as! String?)!)
                        
                    }
                    if dictionary["profileImageURL"] as! String? != nil {
                        
                        self.profileImageURL = dictionary["profileImageURL"] as! String?
                        
                        self.profileImageView.loadImageUsingCacheWithURLString(urlString: self.profileImageURL!)
                        
                        
                    } else {
                        self.profileImageURL = "AddIcon"
                    }
                    
                    if dictionary["Bio"] as? String != nil {
                        self.fullLabel.text = dictionary["Bio"] as! String
                    } else {
                        self.fullLabel.text = "Click update to add a bio..."
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
                
                    
                    
                }
                
                
                
                
                
                
            })
        }
    }
   
    
    func handleMoveToSettings() {
        let segueController = SettingsViewController()
        present(segueController, animated: true, completion: nil)
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
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.5, animations: {
            
         self.profileImageView.alpha = 1.0
        })
    }
    
    
    
    
    func handleAddProfilePic() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
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
        calendarIcon.addTarget(self, action: #selector(handleRecruiter) , for: .touchUpInside)
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
        let profileTinted = profileIconImage?.withRenderingMode(.alwaysTemplate)
        profileIcon.setBackgroundImage(profileTinted, for: .normal)
        profileIcon.tintColor = UIColor(red: 100/255, green: 149/255, blue: 245/255, alpha: 1)

        
        
        
        
    }
    class updateEmployerButtons: UIButton {
        var typeInt: UInt? = nil
    }
    
    func handleMoveToPositionUpdate(sender: updateEmployerButtons) {
        let segueController = SetPositionViewController(nibName: nil, bundle: nil)
        segueController.typeInt = sender.typeInt
        present(segueController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        profileImageView.addObserver(self, forKeyPath: "image", options: NSKeyValueObservingOptions.new, context: nil)
        height2 = self.view.bounds.height
        width = self.view.bounds.width

        if (globalFeedString == "Employer") {
        checkIfUserLoggedInAsStudent()
        } else {
            checkIfUserLoggedInAsEmployer()
        }
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
    
    
    func moveToLinks() {
        let segueController = AddLinkViewController()
        present(segueController, animated: true, completion: nil)
    }
    func chooseVideo(sender: UIButton) {
        let segueController = VideoChooseViewController(nibName: nil, bundle: nil)
        segueController.videoType = sender.tag
        present(segueController, animated: true, completion: nil)
    }

    
    func generateRandomString(length: Int) -> String {
        
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        
        var randString = ""
        
        for _ in 0..<length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randString += String(newCharacter)
            
        }
        
        return randString
    }

    
    
    
    func moveToBio() {
        let segueController = SetBioViewController()
        present(segueController, animated: true, completion: nil)
    }
    
    func moveToSkills() {
        let segueController = SetSkillsViewController()
        present(segueController, animated: true, completion: nil)
    }
    
    func moveToCompanyMission() {
        let segueController = SetMissionViewController()
        present(segueController, animated: true, completion: nil)
    }
    
    
    
    //TABLEVIEW SETUP
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (globalFeedString == "Employer") {
            switch indexPath.row {
            case 0:
                return 60
            case 1:
                return 200
            case 2:
                return 200
            case 3:
                return 200
            case 4:
                return height + 340
            case 5:
                return 5 * height + 150
            default:
                return 120
                
            }
        } else {
            switch indexPath.row {
            case 0, 3:
                return 60
            
            case 1, 2, 4, 5, 6:
                return 150
                
            default:
                 return 80
                
            }
        }
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CellID")
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.selectionStyle = .none
        if (globalFeedString == "Employer") {
       
        switch indexPath.row {
        case 0:
            cell.addSubview(nameLabel)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            nameLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            nameLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 26)
            
            let settingsButton = UIButton()
            cell.addSubview(settingsButton)
            settingsButton.translatesAutoresizingMaskIntoConstraints = false
            let settingsImage = UIImage(named: "SettingsIcon")
            let settingsTinted = settingsImage?.withRenderingMode(.alwaysTemplate)
            settingsButton.setBackgroundImage(settingsTinted, for: .normal)
            settingsButton.tintColor = UIColor.gray
            settingsButton.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            settingsButton.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -15).isActive = true
            settingsButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
            settingsButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
            settingsButton.addTarget(self, action: #selector(handleMoveToSettings), for: .touchUpInside)
            break
        case 1:
            cell.addSubview(profileImageView)
            profileImageView.translatesAutoresizingMaskIntoConstraints = false
            profileImageView.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            profileImageView.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: -10).isActive = true
            profileImageView.layer.borderWidth = 0.5
            
            let changeButton = UIButton()
            cell.addSubview(changeButton)
            changeButton.translatesAutoresizingMaskIntoConstraints = false
            changeButton.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            changeButton.widthAnchor.constraint(equalToConstant: width * 0.65).isActive = true
            changeButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: height2 * 0.02).isActive = true
            
            changeButton.heightAnchor.constraint(equalToConstant: height2 * 0.05).isActive = true
            changeButton.setTitle("Update Picture", for: .normal)
            changeButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
            changeButton.setTitleColor(UIColor.white, for: .normal)
            changeButton.layer.cornerRadius = 10
            changeButton.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
            changeButton.addTarget(self, action: #selector(handleAddProfilePic), for: .touchUpInside)
            
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
//            cell.addSubview(fullLabel)
//            fullLabel.translatesAutoresizingMaskIntoConstraints = false
//            fullLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
//            fullLabel.widthAnchor.constraint(equalToConstant: cell.bounds.width * 0.6).isActive = true
//            fullLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 15).isActive = true
//            fullLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
//            fullLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
//            
//            fullLabel.lineBreakMode = .byWordWrapping
//            fullLabel.numberOfLines = 0
           break
            
            
        case 2:
            let titleLabel = UILabel()
            cell.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.text = "My Bio"
            titleLabel.topAnchor.constraint(equalTo: cell.topAnchor, constant: 10).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            titleLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 24)
            
            cell.addSubview(fullLabel)
            fullLabel.translatesAutoresizingMaskIntoConstraints = false
            fullLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
            fullLabel.widthAnchor.constraint(equalToConstant: cell.bounds.width * 0.6).isActive = true
            fullLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
            fullLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
            fullLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            fullLabel.lineBreakMode = .byWordWrapping
            fullLabel.numberOfLines = 0
            
            let changeButton = UIButton()
            cell.addSubview(changeButton)
            changeButton.translatesAutoresizingMaskIntoConstraints = false
            changeButton.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            changeButton.widthAnchor.constraint(equalToConstant: width * 0.65).isActive = true
            changeButton.topAnchor.constraint(equalTo: fullLabel.bottomAnchor, constant: height2 * 0.04).isActive = true
            
            changeButton.heightAnchor.constraint(equalToConstant: height2 * 0.05).isActive = true
            changeButton.setTitle("Update Skills", for: .normal)
            changeButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
            changeButton.setTitleColor(UIColor.white, for: .normal)
            changeButton.layer.cornerRadius = 10
            changeButton.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
            changeButton.addTarget(self, action: #selector(moveToBio), for: .touchUpInside)
            
            break
        case 3:
            

            let skillLabel = UILabel()
            cell.addSubview(skillLabel)
            skillLabel.text = "Top Skills"
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
            
            
            let changeButton = UIButton()
            cell.addSubview(changeButton)
            changeButton.translatesAutoresizingMaskIntoConstraints = false
            changeButton.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            changeButton.widthAnchor.constraint(equalToConstant: width * 0.65).isActive = true
            changeButton.topAnchor.constraint(equalTo: fourthSkill.bottomAnchor, constant: height2 * 0.04).isActive = true
            
            changeButton.heightAnchor.constraint(equalToConstant: height2 * 0.05).isActive = true
            changeButton.setTitle("Update Skills", for: .normal)
            changeButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
            changeButton.setTitleColor(UIColor.white, for: .normal)
            changeButton.layer.cornerRadius = 10
            changeButton.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
            changeButton.addTarget(self, action: #selector(moveToSkills), for: .touchUpInside)
            
            break
        case 4:
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
            
            cell.addSubview(caption1Label)
            caption1Label.translatesAutoresizingMaskIntoConstraints = false
            caption1Label.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            caption1Label.topAnchor.constraint(equalTo: firstVideoImageView.bottomAnchor, constant: 30).isActive = true
            caption1Label.widthAnchor.constraint(equalTo: firstVideoImageView.widthAnchor).isActive = true
            caption1Label.numberOfLines = 0
            caption1Label.textAlignment = .center
            caption1Label.lineBreakMode = .byWordWrapping
            caption1Label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
            
            //Check here
            
            
            
           
            let changeFirstVideoButton = UIButton()
            cell.addSubview(changeFirstVideoButton)
            changeFirstVideoButton.translatesAutoresizingMaskIntoConstraints = false
            changeFirstVideoButton.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            changeFirstVideoButton.widthAnchor.constraint(equalToConstant: width * 0.65).isActive = true
            changeFirstVideoButton.topAnchor.constraint(equalTo: caption1Label.bottomAnchor, constant: height2 * 0.03).isActive = true
            
            changeFirstVideoButton.heightAnchor.constraint(equalToConstant: height2 * 0.05).isActive = true
            changeFirstVideoButton.setTitle("Update Video", for: .normal)
            changeFirstVideoButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
            changeFirstVideoButton.setTitleColor(UIColor.white, for: .normal)
            changeFirstVideoButton.layer.cornerRadius = 10
            changeFirstVideoButton.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
            changeFirstVideoButton.tag = 1
            changeFirstVideoButton.addTarget(self, action: #selector(chooseVideo), for: .touchUpInside)
            

            if (firstVideoURl == "AddIcon") {
                firstVideoImageView.image = UIImage(named: "NoVideo")
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
        case 5:
            
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
                supplementalImageView.image = UIImage(named: "NoVideo")
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
            supplementalImageView.topAnchor.constraint(equalTo: supplementalVideoLabel.bottomAnchor, constant: 50).isActive = true
            supplementalImageView.layer.borderWidth = 0.5
            supplementalImageView.isUserInteractionEnabled = true
            
            let changeSupplemental1 = UIButton()
            
            cell.addSubview(changeSupplemental1)
            changeSupplemental1.translatesAutoresizingMaskIntoConstraints = false
            changeSupplemental1.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            changeSupplemental1.widthAnchor.constraint(equalToConstant: width * 0.65).isActive = true
            changeSupplemental1.topAnchor.constraint(equalTo: supplementalImageView.bottomAnchor, constant: height2 * 0.03).isActive = true
            changeSupplemental1.heightAnchor.constraint(equalToConstant: height2 * 0.05).isActive = true
            changeSupplemental1.setTitle("Update Video", for: .normal)
            changeSupplemental1.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
            changeSupplemental1.setTitleColor(UIColor.white, for: .normal)
            changeSupplemental1.layer.cornerRadius = 10
            changeSupplemental1.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
            changeSupplemental1.tag = 2
            changeSupplemental1.addTarget(self, action: #selector(chooseVideo), for: .touchUpInside)
            

            cell.addSubview(supplementalImageView2)
            var supplementalPlayButton2 = playButton()
            if (supplementalVideoURL2 == "AddIcon") {
                supplementalImageView2.image = UIImage(named: "NoVideo")
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
            
            let changeSupplemental2 = UIButton()
            cell.addSubview(changeSupplemental2)
            changeSupplemental2.translatesAutoresizingMaskIntoConstraints = false
            changeSupplemental2.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            changeSupplemental2.widthAnchor.constraint(equalToConstant: width * 0.65).isActive = true
            changeSupplemental2.topAnchor.constraint(equalTo: supplementalImageView2.bottomAnchor, constant: height2 * 0.03).isActive = true
            changeSupplemental2.heightAnchor.constraint(equalToConstant: height2 * 0.05).isActive = true
            changeSupplemental2.setTitle("Update Video", for: .normal)
            changeSupplemental2.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
            changeSupplemental2.setTitleColor(UIColor.white, for: .normal)
            changeSupplemental2.layer.cornerRadius = 10
            changeSupplemental2.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
            changeSupplemental2.tag = 3
            changeSupplemental2.addTarget(self, action: #selector(chooseVideo), for: .touchUpInside)
            
            
            cell.addSubview(supplementalImageView3)
            var supplementalPlayButton3 = playButton()
            if (supplementalVideoURL3 == "AddIcon") {
                supplementalImageView3.image = UIImage(named: "NoVideo")
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
            
            let changeSupplemental3 = UIButton()
            
            cell.addSubview(changeSupplemental3)
            changeSupplemental3.translatesAutoresizingMaskIntoConstraints = false
            changeSupplemental3.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            changeSupplemental3.widthAnchor.constraint(equalToConstant: width * 0.65).isActive = true
            changeSupplemental3.topAnchor.constraint(equalTo: supplementalImageView3.bottomAnchor, constant: height2 * 0.03).isActive = true
            changeSupplemental3.heightAnchor.constraint(equalToConstant: height2 * 0.05).isActive = true
            changeSupplemental3.setTitle("Update Video", for: .normal)
            changeSupplemental3.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
            changeSupplemental3.setTitleColor(UIColor.white, for: .normal)
            changeSupplemental3.layer.cornerRadius = 10
            changeSupplemental3.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
            changeSupplemental3.tag = 4
            changeSupplemental3.addTarget(self, action: #selector(chooseVideo), for: .touchUpInside)
            

            
            
            
            
            

            break
            
            
        case 6:
            let linkedInImageView = UIImageView()
            cell.addSubview(linkedInImageView)
            linkedInImageView.translatesAutoresizingMaskIntoConstraints = false
            linkedInImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            linkedInImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            linkedInImageView.centerYAnchor.constraint(equalTo: cell.topAnchor, constant: 140 / 3 - 15).isActive = true
            linkedInImageView.image = UIImage(named: "LinkedinLogo")
            linkedInImageView.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 30).isActive = true
            
            
            
           
            
            cell.addSubview(linkedInTap)
            linkedInTap.translatesAutoresizingMaskIntoConstraints = false
            linkedInTap.centerYAnchor.constraint(equalTo: linkedInImageView.centerYAnchor).isActive = true
            linkedInTap.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            linkedInTap.setTitle("Click Me", for: .normal)
            linkedInTap.setTitleColor(UIColor.blue, for: .normal)
            linkedInTap.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
            linkedInTap.addTarget(self, action: #selector(handleURL), for: .touchUpInside)
            
            
            let changeButton = UIButton()
            cell.addSubview(changeButton)
            changeButton.translatesAutoresizingMaskIntoConstraints = false
            changeButton.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            changeButton.widthAnchor.constraint(equalToConstant: width * 0.65).isActive = true
            changeButton.topAnchor.constraint(equalTo: linkedInTap.bottomAnchor, constant: height2 * 0.04).isActive = true
            
            changeButton.heightAnchor.constraint(equalToConstant: height2 * 0.05).isActive = true
            changeButton.setTitle("Add More Links", for: .normal)
            changeButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
            changeButton.setTitleColor(UIColor.white, for: .normal)
            changeButton.layer.cornerRadius = 10
            changeButton.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
            changeButton.addTarget(self, action: #selector(moveToLinks), for: .touchUpInside)
            

//       
//            
//            cell.addSubview(githubTap)
//            githubTap.translatesAutoresizingMaskIntoConstraints = false
//            githubTap.centerYAnchor.constraint(equalTo: githubImageView.centerYAnchor).isActive = true
//            githubTap.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
//            githubTap.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
//            githubTap.setTitle("Click Me", for: .normal)
//            githubTap.setTitleColor(UIColor.blue, for: .normal)
//            githubTap.addTarget(self, action: #selector(handleURL), for: .touchUpInside)
//
//            cell.addSubview(bruinTap)
//            bruinTap.translatesAutoresizingMaskIntoConstraints = false
//            bruinTap.centerYAnchor.constraint(equalTo: bruinImageView.centerYAnchor).isActive = true
//            bruinTap.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
//            bruinTap.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)!
//            bruinTap.setTitle("Click Me", for: .normal)
//            bruinTap.setTitleColor(UIColor.blue, for: .normal)
//            bruinTap.addTarget(self, action: #selector(handleURL), for: .touchUpInside)
//
            
        default:
            
            
            break
        }
        } else {
            switch indexPath.row {
            case 0:
                cell.addSubview(nameLabel)
                nameLabel.translatesAutoresizingMaskIntoConstraints = false
                nameLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
                nameLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
                nameLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 20)
                
                let settingsButton = UIButton()
                cell.addSubview(settingsButton)
                settingsButton.translatesAutoresizingMaskIntoConstraints = false
                let settingsImage = UIImage(named: "SettingsIcon")
                let settingsTinted = settingsImage?.withRenderingMode(.alwaysTemplate)
                settingsButton.setBackgroundImage(settingsTinted, for: .normal)
                settingsButton.tintColor = UIColor.gray
                settingsButton.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
                settingsButton.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -15).isActive = true
                settingsButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
                settingsButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
                settingsButton.addTarget(self, action: #selector(handleMoveToSettings), for: .touchUpInside)
                break
            case 1:
                cell.addSubview(profileImageView)
                profileImageView.translatesAutoresizingMaskIntoConstraints = false
                profileImageView.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
                profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
                profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
                profileImageView.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: -10).isActive = true
                profileImageView.layer.borderWidth = 0.5
                let changeButton = UIButton()
                profileImageView.addSubview(changeButton)
                profileImageView.isUserInteractionEnabled = true
                changeButton.translatesAutoresizingMaskIntoConstraints = false
                changeButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
                changeButton.rightAnchor.constraint(equalTo: profileImageView.rightAnchor).isActive = true
                changeButton.setTitle("Update", for: .normal)
                changeButton.setTitleColor(UIColor.black, for: .normal)
                changeButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 8)
                changeButton.layer.backgroundColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 0.6).cgColor
                changeButton.addTarget(self, action: #selector(handleAddProfilePic), for: .touchUpInside)
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
                
//                let updateProfileButton = UIButton()
//                cell.addSubview(updateProfileButton)
//                updateProfileButton.translatesAutoresizingMaskIntoConstraints = false
//                updateProfileButton.topAnchor.constraint(equalTo: cell.topAnchor, constant: 5).isActive = true
//                updateProfileButton.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -5).isActive = true
//                updateProfileButton.setTitle("Update", for: .normal)
//                updateProfileButton.setTitleColor(UIColor.blue, for: .normal)
//                updateProfileButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
//                updateProfileButton.heightAnchor.constraint(equalToConstant: 10).isActive = true
//                updateProfileButton.addTarget(self, action: #selector(moveToBio), for: .touchUpInside)
////                
//                cell.addSubview(fullLabel)
//                fullLabel.translatesAutoresizingMaskIntoConstraints = false
//                fullLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
//                fullLabel.widthAnchor.constraint(equalToConstant: cell.bounds.width * 0.6).isActive = true
//                fullLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 15).isActive = true
//                fullLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
//                fullLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
//                
//                fullLabel.lineBreakMode = .byWordWrapping
//                fullLabel.numberOfLines = 0
                break
                
                
            case 2:
                
                let updateButton = updateEmployerButtons()
                cell.addSubview(updateButton)
                updateButton.translatesAutoresizingMaskIntoConstraints = false
                updateButton.translatesAutoresizingMaskIntoConstraints = false
                updateButton.topAnchor.constraint(equalTo: cell.topAnchor, constant: 5).isActive = true
                updateButton.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -5).isActive = true
                updateButton.setTitle("Update", for: .normal)
                updateButton.setTitleColor(UIColor.blue, for: .normal)
                updateButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
                updateButton.heightAnchor.constraint(equalToConstant: 10).isActive = true
                updateButton.typeInt = 1
                updateButton.addTarget(self, action: #selector(moveToCompanyMission), for: .touchUpInside)
                
                
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
                
                let updateButton = updateEmployerButtons()
                cell.addSubview(updateButton)
                updateButton.translatesAutoresizingMaskIntoConstraints = false
                updateButton.translatesAutoresizingMaskIntoConstraints = false
                updateButton.topAnchor.constraint(equalTo: cell.topAnchor, constant: 5).isActive = true
                updateButton.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -5).isActive = true
                updateButton.setTitle("Update", for: .normal)
                updateButton.setTitleColor(UIColor.blue, for: .normal)
                updateButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
                updateButton.heightAnchor.constraint(equalToConstant: 10).isActive = true
                updateButton.typeInt = 1
                updateButton.addTarget(self, action: #selector(handleMoveToPositionUpdate), for: .touchUpInside)
                
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
                
                let updateButton = updateEmployerButtons()
                cell.addSubview(updateButton)
                updateButton.translatesAutoresizingMaskIntoConstraints = false
                updateButton.translatesAutoresizingMaskIntoConstraints = false
                updateButton.topAnchor.constraint(equalTo: cell.topAnchor, constant: 5).isActive = true
                updateButton.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -5).isActive = true
                updateButton.setTitle("Update", for: .normal)
                updateButton.setTitleColor(UIColor.blue, for: .normal)
                updateButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
                updateButton.heightAnchor.constraint(equalToConstant: 10).isActive = true
                updateButton.typeInt = 2
                updateButton.addTarget(self, action: #selector(handleMoveToPositionUpdate), for: .touchUpInside)
                
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
                
                let updateButton = updateEmployerButtons()
                cell.addSubview(updateButton)
                updateButton.translatesAutoresizingMaskIntoConstraints = false
                updateButton.translatesAutoresizingMaskIntoConstraints = false
                updateButton.topAnchor.constraint(equalTo: cell.topAnchor, constant: 5).isActive = true
                updateButton.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -5).isActive = true
                updateButton.setTitle("Update", for: .normal)
                updateButton.setTitleColor(UIColor.blue, for: .normal)
                updateButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
                updateButton.heightAnchor.constraint(equalToConstant: 10).isActive = true
                updateButton.typeInt = 3
                updateButton.addTarget(self, action: #selector(handleMoveToPositionUpdate), for: .touchUpInside)
               
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
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (globalFeedString == "Employer") {
        return 7
        } else {
            return 8
        }
        
    }
    
    
    
       
    //Image picker stuff
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        
        
        let widthRatio = targetSize.width / image.size.width
        let heightRatio = targetSize.height / image.size.height
        var newSize = CGSize()
        if (widthRatio > heightRatio) {
            newSize = CGSize(width: image.size.width * heightRatio, height: image.size.height * heightRatio)
        } else {
            newSize = CGSize(width: image.size.width * widthRatio, height: image.size.height * heightRatio)
        }
        
        UIGraphicsBeginImageContext(CGSize(width: newSize.width, height: newSize.height))
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    //Pick the image
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var pickedImageFromPicker = UIImage()
        if let editedImage = info["UIImagePickerControllerEditedImage"] {
            pickedImageFromPicker = editedImage as! UIImage
            dismiss(animated: true, completion: nil)
            
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            pickedImageFromPicker = originalImage as! UIImage
            dismiss(animated: true, completion: nil)
            
        }
        
        let someImage = pickedImageFromPicker.jpeg(.high)
        
        profileImageView.image = UIImage(data: someImage!)
        profileImageView.image = resizeImage(image: profileImageView.image!, targetSize: CGSize(width: 130, height: 130))
        uploadIntoDatabase()
    }
    
    
    //Place the image found in picker into the database
    func uploadIntoDatabase() {
        let imageName = NSUUID().uuidString
        
        let storageRef = FIRStorage.storage().reference().child("\(imageName).jpg")
        
        if let uploadData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.05) {
            storageRef.put(uploadData, metadata: nil, completion: {(metadata, error) in
                
                if error != nil {
                    return
                }
                
                
                if let profileImageURL =  metadata?.downloadURL()?.absoluteString {
                    let value = ["profileImageURL": profileImageURL]
                    let uid = FIRAuth.auth()?.currentUser?.uid
                    var ref: FIRDatabaseReference!
                    ref = FIRDatabase.database().reference().child("users").child(uid!)
                    ref.updateChildValues(value)
                    
                }
            })
        }
    }
    


    
    
    
    
    
    

}






