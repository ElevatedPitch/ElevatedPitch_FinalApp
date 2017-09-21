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
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (error) in
                    
                        let segueController = ProfilePageViewController()
                        self.present(segueController, animated: true, completion: nil)
                    
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
            })
            
            
            
            
        } else {
            let alert = UIAlertController(title: "Failure", message: "Passwords Don't Match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
            
        }
    }
    
    func moveBack() {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        
        //Set background color
        self.view.backgroundColor = UIColor.white

        
        
        self.view.addSubview(newPasswordTextField)
        self.view.addSubview(newPasswordTextField2)
        self.view.addSubview(submitButton)
        let backButton = UIButton()
        self.view.addSubview(backButton)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.setImage(UIImage(named: "arrowIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(moveBack), for: .touchUpInside)
        
        let titleLabel = UILabel()
        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Change Your Password"
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 28)
        titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.bounds.height * 0.08).isActive = true
        
        
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        newPasswordTextField.backgroundColor = UIColor.white
        newPasswordTextField.layer.cornerRadius = 3
        newPasswordTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: self.view.bounds.height * 0.1).isActive = true
        newPasswordTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        newPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newPasswordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        newPasswordTextField.layer.masksToBounds = true
        newPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.layer.borderWidth = 0.5
        newPasswordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)

        newPasswordTextField.placeholder = "Enter New Password..."
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
        newPasswordTextField2.layer.borderWidth = 0.5
        newPasswordTextField2.placeholder = "Confirm..."
        newPasswordTextField2.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)

        let continueButton = UIButton()
        self.view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.65).isActive = true
        continueButton.topAnchor.constraint(equalTo: newPasswordTextField2.bottomAnchor, constant: self.view.bounds.height * 0.03).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        continueButton.setTitle("Reset Password", for: .normal)
        continueButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.layer.cornerRadius = 10
        continueButton.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
        continueButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        

        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        
        
        view.addGestureRecognizer(tap)
        
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    
    
}
