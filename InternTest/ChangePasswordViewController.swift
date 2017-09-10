//
//  ChangePasswordViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 7/28/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {
    
    let newPasswordTextField = UITextField()
    let newPasswordTextField2 = UITextField()
    let submitButton = UIButton()
    
    
    func handleSubmit() {
        
        if (newPasswordTextField.text == newPasswordTextField2.text) {
            
            let user = FIRAuth.auth()?.currentUser
            
            
            user?.updatePassword(newPasswordTextField2.text!, completion: { (error) in
             
                
                if (error != nil) {
                    let alert = UIAlertController(title: "Failure", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Success", message: "Password has been changed",  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            })
            
            
            
            
        } else {
            let alert = UIAlertController(title: "Failure", message: "Passwords Don't Match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
            
        }
    }
    override func viewDidLoad() {
        
        //Set background color
        let background = CAGradientLayer()
        background.backgroundColor = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)

        
        
        self.view.addSubview(newPasswordTextField)
        self.view.addSubview(newPasswordTextField2)
        self.view.addSubview(submitButton)
        
        
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        newPasswordTextField.backgroundColor = UIColor.white
        newPasswordTextField.layer.cornerRadius = 3
        newPasswordTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        newPasswordTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        newPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newPasswordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        newPasswordTextField.layer.masksToBounds = true
        newPasswordTextField.isSecureTextEntry = true
        
        
        newPasswordTextField2.translatesAutoresizingMaskIntoConstraints = false
        newPasswordTextField2.translatesAutoresizingMaskIntoConstraints = false
        newPasswordTextField2.backgroundColor = UIColor.white
        newPasswordTextField2.layer.cornerRadius = 3
        newPasswordTextField2.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 30).isActive = true
        newPasswordTextField2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        newPasswordTextField2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newPasswordTextField2.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        newPasswordTextField2.layer.masksToBounds = true
        newPasswordTextField2.isSecureTextEntry = true
        
        
        self.view.addSubview(submitButton)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        submitButton.layer.cornerRadius = 5
        submitButton.layer.masksToBounds = true
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = UIColor.init(red: 100/255, green: 175/255, blue: 220/255, alpha: 1)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.topAnchor.constraint(equalTo: newPasswordTextField2.bottomAnchor, constant: 20).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        
        
        view.addGestureRecognizer(tap)
        
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    
    
}
