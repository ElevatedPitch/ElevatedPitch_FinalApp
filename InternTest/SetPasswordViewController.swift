//
//  StudentPositionViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 2/11/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import Foundation
import UIKit
import Firebase

//This is where students choose their positions
class SetPasswordViewController: UIViewController {
    
    //INITIALIZATION OF VARIABLES 
    
    let checkReminderButton = UIButton()
    let UniversityLabel = UILabel()
    let MajorLabel = UILabel()
    let UniversityTF = UITextField()
    let MajorTF = UITextField()
    let submitButton = UIButton()
    
    
    let password = UITextField()
    let confirmPassword = UITextField()
    var curUser = SignUpUser()
    
    
    //-------------------------------------------------------------------------------------------

    
    //HELPER FUNCTIONS AND VIEWDIDLOAD
    
  
    
    
    
    
    
   
    
    func moveBackToVerification() {
        let segueController = VerificationCodeViewController()
        present(segueController, animated: true, completion: nil)
    }
    
    func handleContinue() {
        
        if (password.text != confirmPassword.text) {
            let alert = UIAlertController(title: "Failure", message: "Passwords don't match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            FIRAuth.auth()?.createUser(withEmail: curUser.email, password: password.text!, completion: { (user: FIRUser?, error) in
            
                if error != nil {
                    var errorString = "We encountered an error: "
                    errorString.append((error?.localizedDescription)!)
                   let alert = UIAlertController(title: "Failure", message: errorString, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                let uid = user?.uid
                let value = NSString(string: "true")
                let dictionary = ["Name": self.curUser.name, "Email": self.curUser.email] as [String : Any]
                    let dictionary2 = ["FirstTimeSignUp": value, "FirstTimeConnect": value, "FirstTimeReject": value, "FirstTimeCalendar": value, "FirstTimeSearch": value]
                FIRDatabase.database().reference().child("users").child(uid!).setValue(dictionary)
                FIRDatabase.database().reference().child("users").child(uid!).child("HelpViews").updateChildValues(dictionary2)

                let segueController = FeedController()
                self.present(segueController, animated: true, completion: nil)
                }
            
            })
           
        }
    }
    
    func handleBackMove() {
        dismiss(animated: true, completion: nil)
    }
    
    
    //View Did Load 
    
    override func viewDidLoad() {
        
        
        self.view.backgroundColor = UIColor.white
        super.viewDidLoad()
       
        
        let titleLabel = UILabel()
        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Set your password"
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 32)
        titleLabel.textColor = UIColor.darkGray
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        
        
        
        let backButton = UIButton()
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.setImage(UIImage(named: "arrowIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(handleBackMove), for: .touchUpInside)
        backButton.contentEdgeInsets = UIEdgeInsetsMake( -3, -3, -3, -3)


        self.view.addSubview(password)
        password.translatesAutoresizingMaskIntoConstraints = false
        password.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.85).isActive = true
        password.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        password.placeholder = "Password"
        password.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16)
        password.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: self.view.bounds.height * 0.02).isActive = true
        password.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        password.layer.backgroundColor = UIColor.white.cgColor
        password.layer.borderColor = UIColor.lightGray.cgColor
        password.layer.borderWidth = 1
        password.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        password.layer.cornerRadius = 5
        password.isSecureTextEntry = true
        
        
        self.view.addSubview(confirmPassword)
        confirmPassword.translatesAutoresizingMaskIntoConstraints = false
        confirmPassword.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.85).isActive = true
        confirmPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmPassword.placeholder = "Confirm Password"
        confirmPassword.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16)
        confirmPassword.topAnchor.constraint(equalTo: password.bottomAnchor, constant: self.view.bounds.height * 0.02).isActive = true
        confirmPassword.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        confirmPassword.layer.backgroundColor = UIColor.white.cgColor
        confirmPassword.layer.borderColor = UIColor.lightGray.cgColor
        confirmPassword.layer.borderWidth = 1
        confirmPassword.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        confirmPassword.layer.cornerRadius = 5
        confirmPassword.isSecureTextEntry = true
        
        let continueButton = UIButton()
        self.view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.65).isActive = true
        continueButton.topAnchor.constraint(equalTo: view.topAnchor, constant: self.view.bounds.height * 0.37).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        continueButton.setTitle("Let's Get Started", for: .normal)
        continueButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.layer.cornerRadius = 10
        continueButton.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
        continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        
        view.addGestureRecognizer(tap)
        
        
    }
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

  
    
    
}

