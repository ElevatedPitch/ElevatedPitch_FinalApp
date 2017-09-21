//
//  StudentScreenshotViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 9/15/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import UIKit
import Firebase
class StudentScreenshotViewController: UIViewController {

    
    var user = User()
    var passedInString = String()
    var passedInInt = Int()
    var searchBool = false
    var firstSkill = UILabel()
    var secondSkill = UILabel()
    var thirdSkill = UILabel()
    var fourthSkill = UILabel()

    var bioText = UILabel()

    
    func fetchInformation() {
        
        let ref = FIRDatabase.database().reference().child("users").child(user.uid).observe(.value, with: { (snapshot) in
            let dictionary = snapshot.value as! [String: AnyObject]
            if (dictionary["Bio"] as? String != nil) {
                self.bioText.text = dictionary["Bio"] as! String
            } else {
                self.bioText.text = "No Bio Available"
            }
            
            
            if (dictionary["Skill 1"] as? String != nil) {
                self.firstSkill.text = dictionary["Skill 1"] as! String
            } else {
                self.firstSkill.text = "N/A"
                
            }
            if (dictionary["Skill 2"] as? String != nil) {
                self.secondSkill.text = dictionary["Skill 2"] as! String
            } else {
                self.secondSkill.text = "N/A"
                
            }
            
            if (dictionary["Skill 3"] as? String != nil) {
                self.thirdSkill.text = dictionary["Skill 3"] as! String
            } else {
                self.thirdSkill.text = "N/A"
                
            }
            
            if (dictionary["Skill 4"] as? String != nil) {
                self.fourthSkill.text = dictionary["Skill 4"] as! String
            } else {
                self.fourthSkill.text = "N/A"
                
            }
            
            
        })
    }
    
  
   
    
    
    func exitScreenshot() {
        dismiss(animated: true, completion: nil)
    }
    
    func swipeUp() {
        let segueController = FeedController(nibName: nil, bundle: nil)
        segueController.passedInString = self.passedInString
        segueController.passedInInt = self.passedInInt
        segueController.searchBool = self.searchBool
        present(segueController, animated: true, completion: nil)
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchInformation()
        self.view.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
        let containerView = UIView()
        self.view.addSubview(containerView)
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60).isActive = true
        containerView.layer.cornerRadius = 5
        
        let profilePic = UIImageView()
        containerView.addSubview(profilePic)
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        profilePic.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        profilePic.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 50).isActive = true
        profilePic.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profilePic.widthAnchor.constraint(equalTo: profilePic.heightAnchor).isActive = true
        profilePic.loadImageUsingCacheWithURLString(urlString: user.profileImageURL)
        
        let titleLabel = UILabel()
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 30).isActive = true
        titleLabel.text = user.name
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 30)
        
        
        

        
       
        let crossIcon = UIButton()
        self.view.addSubview(crossIcon)
        crossIcon.translatesAutoresizingMaskIntoConstraints = false
        crossIcon.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        crossIcon.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -25).isActive = true
        crossIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        crossIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let crossImage = UIImage(named: "blackCrossIcon")
        let crossTinted = crossImage?.withRenderingMode(.alwaysTemplate)
        crossIcon.setBackgroundImage(crossTinted, for: .normal)
        crossIcon.tintColor = UIColor.white
        crossIcon.imageEdgeInsets = UIEdgeInsets(top: -10, left: -self.view.bounds.width / 2, bottom: -10, right: -self.view.bounds.width / 2)
        crossIcon.addTarget(self, action: #selector(exitScreenshot), for: .touchUpInside)
        
        let exitButton = UIButton()
        self.view.addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        exitButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        exitButton.topAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width ).isActive = true
        exitButton.addTarget(self, action: #selector(exitScreenshot), for: .touchUpInside)
    
        
        
//        var swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(exitScreenshot))
//        swipeDown.direction = UISwipeGestureRecognizerDirection.down
//        self.view.addGestureRecognizer(swipeDown)
//        
//        var swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeUp))
//        swipeUp.direction = UISwipeGestureRecognizerDirection.up
//        self.view.addGestureRecognizer(swipeUp)
        
        var lineView = UIView()
        containerView.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 100).isActive = true
        lineView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        lineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        lineView.backgroundColor = UIColor.black
        
        var bioTitleLabel = UILabel()
        containerView.addSubview(bioTitleLabel)
        bioTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        bioTitleLabel.text = "About Me"
        bioTitleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bioTitleLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 20).isActive = true
        bioTitleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 24)
        
        
        containerView.addSubview(bioText)
        bioText.translatesAutoresizingMaskIntoConstraints = false
        bioText.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        bioText.topAnchor.constraint(equalTo: bioTitleLabel.bottomAnchor, constant: 10).isActive = true
        bioText.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        bioText.lineBreakMode = .byWordWrapping
        bioText.numberOfLines = 0
        bioText.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.65).isActive = true
        bioText.textAlignment = .center
        
        var lineView2 = UIView()
        containerView.addSubview(lineView2)
        lineView2.translatesAutoresizingMaskIntoConstraints = false
        lineView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView2.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 100).isActive = true
        lineView2.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        lineView2.topAnchor.constraint(equalTo: bioText.bottomAnchor, constant: 20).isActive = true
        lineView2.backgroundColor = UIColor.black
        
        var skillsTitleLabel = UILabel()
        containerView.addSubview(skillsTitleLabel)
        skillsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        skillsTitleLabel.text = "Skills"
        skillsTitleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        skillsTitleLabel.topAnchor.constraint(equalTo: lineView2.bottomAnchor, constant: 20).isActive = true
        skillsTitleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 24)
        
        let skillLabelWidth = self.view.bounds.width * 0.75 * 0.5

        let firstSkillContainerView = UIView()
        
        containerView.addSubview(firstSkillContainerView)
        firstSkillContainerView.addSubview(firstSkill)
        firstSkillContainerView.translatesAutoresizingMaskIntoConstraints = false
        firstSkillContainerView.widthAnchor.constraint(equalToConstant: skillLabelWidth).isActive = true
        firstSkillContainerView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: (self.view.bounds.width - skillLabelWidth) / 6).isActive = true
        firstSkillContainerView.topAnchor.constraint(equalTo: skillsTitleLabel.bottomAnchor, constant: 10).isActive = true
        firstSkillContainerView.heightAnchor.constraint(equalTo: firstSkill.heightAnchor).isActive = true
        firstSkillContainerView.layer.borderWidth = 0.5
        firstSkillContainerView.layer.borderColor = UIColor.gray.cgColor
        firstSkillContainerView.layer.masksToBounds = true
        
        
        
        firstSkill.translatesAutoresizingMaskIntoConstraints = false
        firstSkill.centerXAnchor.constraint(equalTo: firstSkillContainerView.centerXAnchor).isActive = true
        firstSkill.centerYAnchor.constraint(equalTo: firstSkillContainerView.centerYAnchor).isActive = true
        firstSkill.font = UIFont(name: "AppleSDGothicNeo-Light", size: 18)
        
        
        let secondSkillContainerView = UIView()
        containerView.addSubview(secondSkillContainerView)
        secondSkillContainerView.addSubview(secondSkill)
        secondSkillContainerView.translatesAutoresizingMaskIntoConstraints = false
        secondSkillContainerView.topAnchor.constraint(equalTo: firstSkillContainerView.topAnchor).isActive = true
        secondSkillContainerView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: (skillLabelWidth - self.view.bounds.width) / 6).isActive = true
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
        containerView.addSubview(thirdSkillContainerView)
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
        containerView.addSubview(fourthSkillContainerView)
        fourthSkillContainerView.addSubview(fourthSkill)
        
        fourthSkillContainerView.addSubview(fourthSkill)
        fourthSkillContainerView.translatesAutoresizingMaskIntoConstraints = false
        fourthSkillContainerView.topAnchor.constraint(equalTo: thirdSkillContainerView.topAnchor).isActive = true
        fourthSkillContainerView.rightAnchor.constraint(equalTo: secondSkillContainerView.rightAnchor).isActive = true
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
        
        
        var lineView3 = UIView()
        containerView.addSubview(lineView3)
        lineView3.translatesAutoresizingMaskIntoConstraints = false
        lineView3.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView3.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 100).isActive = true
        lineView3.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        lineView3.topAnchor.constraint(equalTo: fourthSkillContainerView.bottomAnchor, constant: 20).isActive = true
        lineView3.backgroundColor = UIColor.black
        
        let screenshotLabel = UILabel()
        containerView.addSubview(screenshotLabel)
        screenshotLabel.translatesAutoresizingMaskIntoConstraints = false
        screenshotLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        screenshotLabel.topAnchor.constraint(equalTo: lineView3.bottomAnchor, constant: 20).isActive = true
        screenshotLabel.text = "This is just a screenshot of the user. For more information (including links and supplementary videos), click the green arrow and connect!"
        screenshotLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        screenshotLabel.numberOfLines = 0
        screenshotLabel.lineBreakMode = .byWordWrapping
        screenshotLabel.textAlignment = .center
        screenshotLabel.widthAnchor.constraint(equalTo: bioText.widthAnchor).isActive = true
        
        
        
        
    }
        // Do any additional setup after loading the view.
    
    
  

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
