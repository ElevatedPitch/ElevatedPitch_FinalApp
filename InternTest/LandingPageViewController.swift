//
//  LandingPageViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 1/4/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import UIKit
import Firebase

//This is the View Controller you see on the First page. Right when the app opens

class LandingPageViewController: UIViewController {

    //INITIALIZATION OF VARIABLES 
    let containerView = UIView()

    let logoImageView = UIImageView()
    let titleLabel = UILabel()
    let registerButton = UIButton()
    let loginButton = UIButton()
  
    let emailTf = UITextField()
    
    let passwordTF = UITextField()
    let cancelButton = UIButton()

    //-------------------------------------------------------------------------------------------

    
    //HELPER FUNCTIONS AND VIEW DID LOAD
    //This moves you to the registration controller if the user needs to create a new profile
    

    //Move to login screen
    func checkEmailTF(email: String) -> Bool {
        if (email.contains("g.ucla.edu") || email.contains("ucla.edu")) {
            return true
        }
        return true
        
    }
    //Login into the APP
    func handleMoveToFeed() {

        let email = emailTf.text!
        let password = passwordTF.text!
        
        if (!checkEmailTF(email: email)) {
            let alert = UIAlertController(title: "Failure", message: "Not from UCLA", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {  (user, error) in
                
                if error != nil {
                    let alert = UIAlertController(title: "Failure", message: "Email or Password is wrong ", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                else {
                    let segueController = FeedController()
                    self.emailTf.text = ""
                    self.passwordTF.text = ""
                    segueController.previousController = LandingPageViewController()
                    self.present(segueController, animated: true, completion: nil)
                    
                }
                
            })
        }
    }

    //Needed if the user wants to dismiss keyboard
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    //Lock Screen
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(orientation: .portrait)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AppUtility.lockOrientation(orientation: .all)
    }
    
    
    
    func handleMoveToRegistration() {
        keyboardWillHide()
        let segueController = SetNameViewController()
        self.emailTf.text = ""
        self.passwordTF.text = ""
        present(segueController, animated: true, completion: nil)
        
        
    }
    func handleForgotPassword() {
        
        
        if (emailTf.text == "") {
            let alert = UIAlertController(title: "Failure", message: "Please enter an email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: emailTf.text!, completion: { (error) in
            
            
            
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
    
    func keyboardWillShow() {
        
        
        
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveLinear, animations: {
            
            self.cancelButton.isHidden = false
            
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= self.view.bounds.height * 0.6
            }
            
            
            }, completion: { (finished: Bool) in
        })
        
    }
    func keyboardWillHide() {

        UIView.animate(withDuration: 0.35, delay: 0, options: .curveLinear, animations: {
            self.view.endEditing(true)
            self.cancelButton.isHidden = true
            
            self.emailTf.resignFirstResponder()
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += self.view.bounds.height * 0.6
            }
            }, completion: { (finished: Bool) in
                
        })
        
        
        }
    
   
    
    //View did load
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardWillHide()
        self.view.backgroundColor = UIColor.white
        
        
        //New Set up 
        let backLayer = CALayer()
        backLayer.backgroundColor = UIColor.white.cgColor
        backLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height * 1.8)
        self.view.layer.addSublayer(backLayer)
        let gradientLayer = CAGradientLayer()
        
        
        let topColor = UIColor(red: (0/255.0), green: (191/255.0), blue: (235/255.0), alpha: 1 )
        let bottomColor = UIColor(red: (0/255.0), green: (120/255.0), blue: (255/255.0), alpha: 1 )
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        
        
        gradientLayer.frame = self.view.bounds
        self.view.layer.addSublayer(gradientLayer)

        self.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.4).isActive = true
        containerView.layer.backgroundColor = UIColor.white.cgColor
        
        containerView.addSubview(emailTf)
        emailTf.translatesAutoresizingMaskIntoConstraints = false
        emailTf.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.85).isActive = true
        emailTf.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTf.placeholder = "Email"
        emailTf.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16)
        emailTf.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 50).isActive = true
        emailTf.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        emailTf.layer.backgroundColor = UIColor.white.cgColor
        emailTf.layer.borderColor = UIColor.lightGray.cgColor
        emailTf.layer.borderWidth = 1
        emailTf.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        emailTf.layer.cornerRadius = 5
        emailTf.addTarget(self, action: #selector(keyboardWillShow), for: .editingDidBegin)
       
        containerView.addSubview(passwordTF)
        passwordTF.translatesAutoresizingMaskIntoConstraints = false
        passwordTF.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.85).isActive = true
        passwordTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTF.placeholder = "Password"
        passwordTF.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16)
        passwordTF.topAnchor.constraint(equalTo: emailTf.bottomAnchor, constant: 15).isActive = true
        passwordTF.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        passwordTF.layer.backgroundColor = UIColor.white.cgColor
        passwordTF.layer.borderColor = UIColor.lightGray.cgColor
        passwordTF.layer.borderWidth = 1
        passwordTF.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        passwordTF.layer.cornerRadius = 5
        passwordTF.isSecureTextEntry = true
        passwordTF.addTarget(self, action: #selector(keyboardWillShow), for: .editingDidBegin)

        
        
     
        self.navigationController?.navigationBar.isHidden = true
        
        
        
        let loginButton = UIButton()
        containerView.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.65).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordTF.bottomAnchor, constant: 15).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.setTitle("Log In", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        loginButton.layer.cornerRadius = 10
        loginButton.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
        loginButton.addTarget(self, action: #selector(handleMoveToFeed), for: .touchUpInside)
        
        let forgotPassword = UIButton()
        containerView.addSubview(forgotPassword)
        forgotPassword.translatesAutoresizingMaskIntoConstraints = false
        forgotPassword.topAnchor.constraint(equalTo: loginButton.bottomAnchor).isActive = true
        forgotPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forgotPassword.setTitleColor(UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1), for: .normal)
        forgotPassword.setTitle("Forgot your password?", for: .normal)
        forgotPassword.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        forgotPassword.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        
        let lineView = UIView()
        containerView.addSubview(lineView)
        
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.bottomAnchor.constraint(equalTo: forgotPassword.bottomAnchor, constant: 5).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.layer.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1).cgColor
        lineView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        
        let container2 = UIView()
        containerView.addSubview(container2)
        container2.translatesAutoresizingMaskIntoConstraints = false
        container2.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container2.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container2.topAnchor.constraint(equalTo: lineView.bottomAnchor).isActive = true
        container2.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
        let signUpLabel = UILabel()
        container2.addSubview(signUpLabel)
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel.textColor = UIColor.gray
        signUpLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        signUpLabel.text = "Don't have an account? "
        signUpLabel.centerYAnchor.constraint(equalTo: container2.centerYAnchor).isActive = true
        signUpLabel.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 55).isActive = true
        
     
        let signUpButton = UIButton()
        container2.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.leftAnchor.constraint(equalTo: signUpLabel.rightAnchor).isActive = true
        signUpButton.centerYAnchor.constraint(equalTo: container2.centerYAnchor).isActive = true
        signUpButton.setTitleColor(UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1), for: .normal)
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        signUpButton.addTarget(self, action: #selector(handleMoveToRegistration), for: .touchUpInside)
      
        containerView.addSubview(cancelButton)
        cancelButton.isHidden = true
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        cancelButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        cancelButton.addTarget(self, action: #selector(keyboardWillHide), for: .touchUpInside)
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(tap)
        
    }

   
  

   

}
