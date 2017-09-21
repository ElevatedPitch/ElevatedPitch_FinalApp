//
//  LoginViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 6/24/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import Foundation
import UIKit
import Firebase
//This is what happens when you click the Login Button on LandingPage. Logs a user in 
class SetNameViewController: UIViewController {
    
    
    //INTIALIZATION OF VARIABLES
    let titleLabel = UILabel()
    let EmailLabel = UILabel()
    let PasswordLabel = UILabel()
    let emailTF = UITextField()
    let passwordTF = UITextField()
    
    let backArrow = UIButton()
    
    let loginButton = UIButton()
    let firstNameTF = UITextField()
    let lastNameTF = UITextField()
    var curUser = SignUpUser()
    
    
    //-------------------------------------------------------------------------------------------

    //HELPER FUNCTIONS AND VIEW DID LOAD 
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
  
    //Go back to the landing page
    func handleMoveToLanding() {
        dismissKeyboard()
        dismiss(animated: true, completion: nil)
    }
    func handleMoveToEmail() {
        let signUpUser = SignUpUser()
        if (firstNameTF.text == "" || lastNameTF.text == "") {
            let alert = UIAlertController(title: "Failure", message: "Please enter a name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        } else {
        signUpUser.name = firstNameTF.text!
        signUpUser.name.append(lastNameTF.text!)
        let segueController = SetEmailViewController()
        segueController.curUser = signUpUser
            firstNameTF.text = ""
            lastNameTF.text = ""
            present(segueController, animated: true, completion: nil)

        }
    }
    
    
    func handleMoveToRecruiterVal() {
        
        let segueController = VerificationCodeViewController()
        curUser.previousController = "SetNameViewController"
        
        segueController.curUser = curUser
        segueController.typeInt = 1
        firstNameTF.text = ""
        lastNameTF.text = ""
        present(segueController, animated: true, completion: nil)
        
    }
    class linkButton: UIButton {
        var linkURL = String()
    }
    
    
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
    //View Did load 
    

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        super.viewDidLoad()
        
        
 
        let backButton = UIButton()
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.contentEdgeInsets = UIEdgeInsetsMake(-3, -3, -3, -3)
        backButton.setImage(UIImage(named: "arrowIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(handleMoveToLanding), for: .touchUpInside)
        
        let titleLabel = UILabel()
        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "What's your name?"
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 32)
        titleLabel.textColor = UIColor.darkGray
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.bounds.height * 0.08).isActive = true
        
        
        self.view.addSubview(firstNameTF)
        firstNameTF.translatesAutoresizingMaskIntoConstraints = false
        firstNameTF.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.85).isActive = true
        firstNameTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        firstNameTF.placeholder = "First Name"
        firstNameTF.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16)
        firstNameTF.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: self.view.bounds.height * 0.02).isActive = true
        firstNameTF.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        firstNameTF.layer.backgroundColor = UIColor.white.cgColor
        firstNameTF.layer.borderColor = UIColor.lightGray.cgColor
        firstNameTF.layer.borderWidth = 1
        firstNameTF.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        firstNameTF.layer.cornerRadius = 5
        
        self.view.addSubview(lastNameTF)
        lastNameTF.translatesAutoresizingMaskIntoConstraints = false
        lastNameTF.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.85).isActive = true
        lastNameTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lastNameTF.placeholder = "Last Name"
        lastNameTF.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16)
        lastNameTF.topAnchor.constraint(equalTo: firstNameTF.bottomAnchor, constant: self.view.bounds.height * 0.02).isActive = true
        lastNameTF.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        lastNameTF.layer.backgroundColor = UIColor.white.cgColor
        lastNameTF.layer.borderColor = UIColor.lightGray.cgColor
        lastNameTF.layer.borderWidth = 1
        lastNameTF.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        lastNameTF.layer.cornerRadius = 5
        
        
        
        let disclaimerLabel = UILabel()
        self.view.addSubview(disclaimerLabel)
        disclaimerLabel.translatesAutoresizingMaskIntoConstraints = false
        disclaimerLabel.text = "By tapping Sign Up, you are agree to the"
        disclaimerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        disclaimerLabel.heightAnchor.constraint(equalTo: lastNameTF.heightAnchor).isActive = true
        disclaimerLabel.topAnchor.constraint(equalTo: lastNameTF.bottomAnchor, constant: self.view.bounds.height * 0.02).isActive = true
        disclaimerLabel.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 15)
        
        
        let servicesButton = linkButton()
        self.view.addSubview(servicesButton)
        servicesButton.linkURL = "https://elevatedpitch.github.io/privacypolicy.html"
        servicesButton.translatesAutoresizingMaskIntoConstraints = false
        servicesButton.leftAnchor.constraint(equalTo: disclaimerLabel.leftAnchor, constant: 2).isActive = true
        servicesButton.topAnchor.constraint(equalTo: disclaimerLabel.bottomAnchor).isActive = true
        servicesButton.heightAnchor.constraint(equalToConstant: 10).isActive = true
        servicesButton.setTitle("Terms of Services", for: .normal)
        servicesButton.setTitleColor(UIColor(red: 100/255, green: 149/255, blue: 245/255, alpha: 1), for: .normal)
        servicesButton.titleLabel?.font =  UIFont(name: "AppleSDGothicNeo-Bold" , size: 15)
        servicesButton.addTarget(self, action: #selector(handleURL), for: .touchUpInside)
        //Cannot believe I have a separate label for this
        let andLabel = UILabel()
        self.view.addSubview(andLabel)
        andLabel.translatesAutoresizingMaskIntoConstraints = false
        andLabel.leftAnchor.constraint(equalTo: servicesButton.rightAnchor).isActive = true
        andLabel.heightAnchor.constraint(equalTo: servicesButton.heightAnchor).isActive = true
        andLabel.text = " and "
        andLabel.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 15)
        andLabel.topAnchor.constraint(equalTo: servicesButton.topAnchor).isActive = true
        andLabel.bottomAnchor.constraint(equalTo: servicesButton.bottomAnchor).isActive = true
        
        
        
        let privacyButton = linkButton()
        self.view.addSubview(privacyButton)
        privacyButton.linkURL = "https://elevatedpitch.github.io/privacypolicy.html"
        privacyButton.translatesAutoresizingMaskIntoConstraints = false
        privacyButton.leftAnchor.constraint(equalTo: andLabel.rightAnchor).isActive = true
        privacyButton.topAnchor.constraint(equalTo: disclaimerLabel.bottomAnchor).isActive = true
        privacyButton.heightAnchor.constraint(equalToConstant: 10).isActive = true
        privacyButton.setTitle("Privacy Policy", for: .normal)
        privacyButton.setTitleColor(UIColor(red: 100/255, green: 149/255, blue: 245/255, alpha: 1), for: .normal)
        privacyButton.titleLabel?.font =  UIFont(name: "AppleSDGothicNeo-Bold" , size: 15)
        privacyButton.addTarget(self, action: #selector(handleURL), for: .touchUpInside)
        
        let signUpButton = UIButton()
        self.view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.65).isActive = true
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.layer.cornerRadius = 10
        signUpButton.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
        signUpButton.topAnchor.constraint(equalTo: andLabel.bottomAnchor, constant: self.view.bounds.height * 0.02).isActive = true
        signUpButton.addTarget(self, action: #selector(handleMoveToEmail), for: .touchUpInside)
        
        
        let disclaimerLabel3 = UILabel()
        self.view.addSubview(disclaimerLabel3)
        disclaimerLabel3.translatesAutoresizingMaskIntoConstraints = false
        disclaimerLabel3.text = "Are you a recruiter?"
        disclaimerLabel3.topAnchor.constraint(equalTo: signUpButton.bottomAnchor).isActive = true
        disclaimerLabel3.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        disclaimerLabel3.heightAnchor.constraint(equalTo: firstNameTF.heightAnchor).isActive = true
        disclaimerLabel3.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 15)
        
        let recruiterButton = UIButton()
        self.view.addSubview(recruiterButton)
        recruiterButton.translatesAutoresizingMaskIntoConstraints = false
        recruiterButton.topAnchor.constraint(equalTo: disclaimerLabel3.bottomAnchor).isActive = true
        recruiterButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        recruiterButton.setTitle(" Click here", for: .normal)
        recruiterButton.addTarget(self, action: #selector(handleMoveToRecruiterVal), for: .touchUpInside)
        recruiterButton.setTitleColor(UIColor(red: 100/255, green: 149/255, blue: 245/255, alpha: 1), for: .normal)
        recruiterButton.titleLabel?.font =  UIFont(name: "AppleSDGothicNeo-Bold" , size: 15)

        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)
    }
}


