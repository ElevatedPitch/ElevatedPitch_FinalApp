//
//  ForgotPasswordLandingViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 7/28/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import Firebase

class ForgotPasswordLandingViewController: UIViewController {

    //Don't touch
    var errorBoolForFirebaseCall = false

    
    
    
    class submitButton: UIButton {
        var emailString: String? = nil
        var passwordString: String? = nil
        
    }
    
    var titleLabel = UILabel()
    var descriptionLabel = UILabel()
    var emailTextField = UITextField()
    var passwordResetButton =  submitButton()

    
    
  
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

        view.addGestureRecognizer(tap)

        //Add turquoise background
        let background = CAGradientLayer()
        background.backgroundColor = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
        
        
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordResetButton)
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        titleLabel.font = UIFont(name: "Didot", size: 30)
        titleLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.text = "Password Help"
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        descriptionLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        descriptionLabel.font = UIFont(name: "Didot", size: 15)
        descriptionLabel.text = "Give us your email and we'll send a temporary password for you to use"
        
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.backgroundColor = UIColor.white
        emailTextField.layer.cornerRadius = 3
        emailTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        emailTextField.layer.masksToBounds = true

        
        
        
        
        
        passwordResetButton.translatesAutoresizingMaskIntoConstraints = false
        passwordResetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordResetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        passwordResetButton.widthAnchor.constraint(equalTo: titleLabel.widthAnchor).isActive = true
        passwordResetButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        passwordResetButton.backgroundColor = UIColor.init(red: 0/255, green: 153/255, blue: 204/255, alpha: 1)
        passwordResetButton.addTarget(self, action: #selector(handlePasswordReset), for: .touchUpInside)
        passwordResetButton.layer.cornerRadius = 5
        passwordResetButton.layer.masksToBounds = true
        passwordResetButton.titleLabel?.text = "Submit"
        passwordResetButton.titleLabel?.font = UIFont(name: "Didot", size: 25)
        passwordResetButton.passwordString = generateRandomString(length: 8)
        passwordResetButton.emailString = emailTextField.text
        passwordResetButton.addTarget(self, action: #selector(handlePasswordReset), for: .touchUpInside)
        
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
    
    func changePassword(password: String, completion: @escaping (Bool) -> ()) {
        let ref = FIRDatabase.database().reference().child("users")
        let email = emailTextField.text
        errorBoolForFirebaseCall = false
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
                var dictionary = rest.value as! [String: AnyObject]
                if (dictionary["email"] as? String != nil) {
                  
                if (dictionary["email"] as? String == email) {
                    dictionary["password"] = password as AnyObject
                    ref.child(rest.key).setValue(dictionary)
                    completion(true)
                }
                }
            }
           completion(false)

        })
        
    }
   
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func handlePasswordReset(sender: submitButton) {
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: emailTextField.text!, completion: { (error) in
            
            
            
            if (error != nil) {
                let alert = UIAlertController(title: "Failure", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                let alert = UIAlertController(title: "Success", message: "Email sent to reset password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            })
        
    
    }
    
    
    
    
}
