//
//  SettingsViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 8/30/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    
    let password1TextField = UITextField()
    let password2TextField = UITextField()
    
    func moveToProfile() {
        let segueController = ProfilePageViewController()
        present(segueController, animated: true, completion: nil)
    }
    
    func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let segueController = LandingPageViewController()
        present(segueController, animated: true, completion: nil)
        
    
    }
    
    
    
    func handleResetPassword() {
        if (password1TextField.text == password2TextField.text && password1TextField.text != "") {
        FIRAuth.auth()?.currentUser?.updatePassword(password2TextField.text!,  completion: { (error) in
            
            if (error != nil) {
                let alert = UIAlertController(title: "Failure", message: "Could not update password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
            let segueController = ProfilePageViewController()
            present(segueController, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Failure", message: "Passwords don't match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleLabel = UILabel()
        let backButton = UIButton()
        let continueButton = UIButton()
        self.view.addSubview(titleLabel)
        self.view.addSubview(backButton)
        self.view.addSubview(continueButton)
        
        self.view.backgroundColor = UIColor.white
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.setImage(UIImage(named: "arrowIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(moveToProfile), for: .touchUpInside)
        
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Settings"
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 26)
        titleLabel.textColor = UIColor.darkGray
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.bounds.height * 0.08).isActive = true
        
        
        let forgotPasswordLabel = UILabel()
        self.view.addSubview(forgotPasswordLabel)
        forgotPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        forgotPasswordLabel.centerYAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: self.view.bounds.height * 0.06).isActive = true
        forgotPasswordLabel.text = "Change Password"
        forgotPasswordLabel.textColor = UIColor.darkGray
        forgotPasswordLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 21)
        
        
     

        self.view.addSubview(password1TextField)
        password1TextField.translatesAutoresizingMaskIntoConstraints = false
        password1TextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        password1TextField.centerYAnchor.constraint(equalTo: forgotPasswordLabel.bottomAnchor, constant: self.view.bounds.height * 0.08).isActive = true
        password1TextField.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.85).isActive = true
        password1TextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        password1TextField.placeholder = "Enter New Password..."
        password1TextField.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16)
        password1TextField.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        password1TextField.layer.backgroundColor = UIColor.white.cgColor
        password1TextField.layer.borderColor = UIColor.lightGray.cgColor
        password1TextField.layer.borderWidth = 1
        password1TextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        password1TextField.layer.cornerRadius = 5
        password1TextField.autocapitalizationType = .none
        self.view.addSubview(password2TextField)
        password2TextField.translatesAutoresizingMaskIntoConstraints = false
        password2TextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        password2TextField.centerYAnchor.constraint(equalTo: password1TextField.bottomAnchor, constant: self.view.bounds.height * 0.08).isActive = true
        password2TextField.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.85).isActive = true
        password2TextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        password2TextField.placeholder = "Confirm new password..."
        password2TextField.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16)
        password2TextField.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        password2TextField.layer.backgroundColor = UIColor.white.cgColor
        password2TextField.layer.borderColor = UIColor.lightGray.cgColor
        password2TextField.layer.borderWidth = 1
        password2TextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        password2TextField.layer.cornerRadius = 5
        password2TextField.autocapitalizationType = .none

        self.view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.65).isActive = true
        continueButton.topAnchor.constraint(equalTo: password2TextField.bottomAnchor, constant: self.view.bounds.height * 0.03).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        continueButton.setTitle("Reset Password", for: .normal)
        continueButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.layer.cornerRadius = 10
        continueButton.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
        continueButton.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        
        let logoutButton = UIButton()
        self.view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.65).isActive = true
        logoutButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -self.view.bounds.height * 0.2).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        logoutButton.setTitleColor(UIColor.white, for: .normal)
        logoutButton.layer.cornerRadius = 10
        logoutButton.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
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
