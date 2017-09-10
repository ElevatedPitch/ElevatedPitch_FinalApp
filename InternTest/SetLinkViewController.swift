//
//  SetLinkViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 8/19/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import UIKit
import Firebase
class SetLinkViewController: UIViewController {
    
    
    let titleLabel = UILabel()
    let continueButton = UIButton()
    let backButton = UIButton()
    let LinkedInLink = UILabel()
    let LinkedInTextField = UITextField()
    let githubLink = UILabel()
    let githubTextField = UITextField()
    let bruinViewLink = UILabel()
    let bruinViewTextField = UITextField()
    
    
    
    
    
    func moveToProfile() {
        let segueController = ProfilePageViewController()
        present(segueController, animated: true, completion: nil)
    }
    func uploadToFirebase() {
        let ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
        var value = [String: AnyObject]()
        var uploadString = String()
        if (LinkedInTextField.hasText) {
            if (!(LinkedInTextField.text?.contains("https://"))!) {
                uploadString = "https://"
                uploadString.append(LinkedInTextField.text!)
            } else {
            uploadString = LinkedInTextField.text!
            }
            var firebaseString = NSString(string: uploadString)
            value.updateValue(firebaseString, forKey: "linkedInLink")
        }
        if (githubTextField.hasText) {
            if (!(githubTextField.text?.contains("https://"))!) {
                uploadString = "https://"
                uploadString.append(githubTextField.text!)
            } else {
                uploadString = githubTextField.text!
            }
            uploadString = githubTextField.text!
            var firebaseString = NSString(string: uploadString)
            value.updateValue(firebaseString, forKey: "githubLink")
        }
        if (bruinViewTextField.hasText) {
            if (!(bruinViewTextField.text?.contains("https://"))!) {
                uploadString = "https://"
                uploadString.append(bruinViewTextField.text!)
            } else {
                uploadString = bruinViewTextField.text!
            }
            uploadString = bruinViewTextField.text!
            var firebaseString = NSString(string: uploadString)
            value.updateValue(firebaseString, forKey: "bruinViewLink")
        }
       
        ref.updateChildValues(value)
        moveToProfile()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(LinkedInLink)
        LinkedInLink.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(githubLink)
        githubLink.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bruinViewLink)
        bruinViewLink.translatesAutoresizingMaskIntoConstraints = false
       
        self.view.addSubview(LinkedInTextField)
        LinkedInTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(githubTextField)
        githubTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bruinViewTextField)
        bruinViewTextField.translatesAutoresizingMaskIntoConstraints = false
        
        
        continueButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.65).isActive = true
        continueButton.topAnchor.constraint(equalTo: view.topAnchor, constant: self.view.bounds.height * 0.5).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.layer.cornerRadius = 10
        continueButton.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
        continueButton.addTarget(self, action: #selector(uploadToFirebase), for: .touchUpInside)
        
        
        self.view.backgroundColor = UIColor.white
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.setImage(UIImage(named: "arrowIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(moveToProfile), for: .touchUpInside)
        
        titleLabel.text = "Set your links"
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 32)
        titleLabel.textColor = UIColor.black
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.bounds.height * 0.08).isActive = true
        
        
      
        LinkedInLink.text = "LinkedIn"
        LinkedInLink.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: -20).isActive = true
        githubLink.text = "Github"
        githubLink.leftAnchor.constraint(equalTo: LinkedInLink.leftAnchor).isActive = true
        bruinViewLink.text = "BruinView"
        bruinViewLink.leftAnchor.constraint(equalTo: LinkedInLink.leftAnchor).isActive = true
        
        
        LinkedInLink.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        githubLink.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        bruinViewLink.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        
        LinkedInTextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        githubTextField.heightAnchor.constraint(equalTo: LinkedInTextField.heightAnchor).isActive = true
        bruinViewTextField.heightAnchor.constraint(equalTo: LinkedInTextField.heightAnchor).isActive = true
        
        LinkedInTextField.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.3).isActive = true
        githubTextField.widthAnchor.constraint(equalTo: LinkedInTextField.widthAnchor).isActive = true
        bruinViewTextField.widthAnchor.constraint(equalTo: LinkedInTextField.widthAnchor).isActive = true
        
        
        
        let height = (self.view.bounds.height * 0.45) - ((self.view.bounds.height * 0.08 + 40) + self.view.bounds.height * 0.05)
        
        
        let descriptionLabel = UILabel()
        self.view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "Add links to your profile to further"
        descriptionLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        descriptionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        descriptionLabel.centerYAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: height / 5).isActive = true
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        
        let descriptionLabel2 = UILabel()
        self.view.addSubview(descriptionLabel2)
        descriptionLabel2.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel2.text = "showcase your skills."
        descriptionLabel2.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        descriptionLabel2.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        descriptionLabel2.centerYAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5).isActive = true
        
        LinkedInTextField.centerYAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: height / 5).isActive = true
        LinkedInTextField.leftAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        LinkedInTextField.layer.borderWidth = 0.5
        LinkedInTextField.layer.borderColor = UIColor.darkGray.cgColor
        LinkedInTextField.layer.cornerRadius = 3
        
        githubTextField.centerYAnchor.constraint(equalTo: LinkedInTextField.bottomAnchor, constant: height / 5).isActive = true
        githubTextField.leftAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        githubTextField.layer.borderWidth = 0.5
        githubTextField.layer.borderColor = UIColor.darkGray.cgColor
        githubTextField.layer.cornerRadius = 3
        
        bruinViewTextField.centerYAnchor.constraint(equalTo: githubTextField.bottomAnchor, constant: height / 5).isActive = true
        bruinViewTextField.leftAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bruinViewTextField.layer.borderWidth = 0.5
        bruinViewTextField.layer.borderColor = UIColor.darkGray.cgColor
        bruinViewTextField.layer.cornerRadius = 3
        
        
        LinkedInLink.centerYAnchor.constraint(equalTo: LinkedInTextField.centerYAnchor).isActive = true
        githubLink.centerYAnchor.constraint(equalTo: githubTextField.centerYAnchor).isActive = true
        bruinViewLink.centerYAnchor.constraint(equalTo: bruinViewTextField.centerYAnchor).isActive = true
        
        // Do any additional setup after loading the view.
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
