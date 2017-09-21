//
//  LoginScreenViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 12/21/16.
//  Copyright © 2016 Rahul Sheth. All rights reserved.
//

import UIKit
import Firebase

//This is what happens when you click the Login Button at LandingPageViewController. Logs in Users

class SetBirthdayViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //INITIALIZATION OF ALL VARIABLES 
    
    

    

    
    let titleLabel = UILabel()
    var curUser = SignUpUser()
    let dateField = UITextField()
    let datePicker = UIDatePicker()
    //Login versus register
    
    
    
    //-------------------------------------------------------------------------------------------

    //HELPER FUNCTIONS
    
   
    
    
    //Register the user into the system
       func handleReturnToLogin() {
        let segueController = LandingPageViewController()
        present(segueController, animated: true, completion: nil)
    }
    
    func handleBackMove() {
        dismiss(animated: true, completion: nil)
        
    }
    func dateCheck(date: Date) -> Bool {
        
        let date2 = Date.init(timeIntervalSinceNow: -409968000)
        if (date.timeIntervalSince(date2).isLess(than: 0)) {
            
        
        return true
        }
        return false
        
    }
    
    func handleMoveToEmail() {
        
        if (dateCheck(date: datePicker.date)) {
            let formatter = DateFormatter()
            formatter.dateStyle = DateFormatter.Style.medium
            formatter.timeStyle = DateFormatter.Style.none
            let dateString = formatter.string(from: datePicker.date)
        
        
        let signUpUser = SignUpUser()
    
            let segueController = SetEmailViewController()
            signUpUser.birthday = dateString
            segueController.curUser = signUpUser
            
            present(segueController, animated: true, completion: nil)
            
        } else {
        let alert = UIAlertController(title: "Sorry", message: "You have to be atleast 13 to be on Elevated Pitch", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (alert: UIAlertAction!) in self.handleReturnToLogin()}))
            
            
            
            
            present(alert, animated: true, completion:  nil)
        
        }
        
    }
    
    
  
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        
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

        let titleLabel = UILabel()
        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "What's your Birthday?"
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 32)
        titleLabel.textColor = UIColor.darkGray
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.bounds.height * 0.08).isActive = true
    
        self.view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 2 / 5).isActive = true
        datePicker.datePickerMode = UIDatePickerMode.date
        
        
        let continueButton = UIButton()
        self.view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.65).isActive = true
        continueButton.topAnchor.constraint(equalTo: view.topAnchor, constant: self.view.bounds.height * 0.37).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.layer.cornerRadius = 10
        continueButton.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
        continueButton.addTarget(self, action: #selector(handleMoveToEmail), for: .touchUpInside)

        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view. 
        
    }
    
   
    
   

    
        
        
        

//Keyboard and Status Bar 
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func PreferredStatusBarStyle() -> UIStatusBarStyle {
        return .lightContent
    }
    
}
