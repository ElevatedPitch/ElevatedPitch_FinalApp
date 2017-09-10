//
//  PositionViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 12/24/16.
//  Copyright © 2016 Rahul Sheth. All rights reserved.
//

import Foundation
import UIKit
import Firebase


//This is where Employers choose their Occupation
class SetEmailViewController: UIViewController {
    
    
    let emailTF = UITextField()
    var curUser = SignUpUser()
    //HELPER FUNCTIONS AND VIEW DID LOAD
    
    
  
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
    

    func handleBackMove() {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func handleMoveToRecruiterVal() {
        
        let segueController = VerificationCodeViewController()
        segueController.curUser = curUser
        segueController.typeInt = 1
        present(segueController, animated: true, completion: nil)

    }
    func handleMoveToStudentVal() {
//        if (checkEmailTF(email: emailTF.text!)) {
        
            let passwordString = generateRandomString(length: 6)
            
            
            //Send the email
            let emailSession = MCOSMTPSession()
            emailSession.hostname = "smtp.gmail.com"
            emailSession.username = "elevatedpitchhelp@gmail.com"
            emailSession.password = "rxbqmvdngwxihtvk"
            emailSession.port = 465
            emailSession.authType = MCOAuthType.saslPlain
            emailSession.connectionType = MCOConnectionType.TLS
            emailSession.connectionLogger = { (connectionID, type, data) in
                if data != nil {
                    if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
                        NSLog("Connectionlogger: \(string)")
                        
                    }
                }
                
            }
            
            var builder = MCOMessageBuilder()
            builder.header.to = [MCOAddress(displayName: curUser.name, mailbox: emailTF.text)]
            builder.header.from = MCOAddress(displayName: "Elevated Pitch", mailbox: "elevatedpitchhelp@gmail.com")
            builder.header.subject = "Invitation to Elevated Pitch"
            builder.htmlBody = "Welcome to Elevated Pitch! We've been expecting you! Here is your verification code: "
            builder.htmlBody.append(passwordString)
            let sendData = builder.data()
            let send = emailSession.sendOperation(with: sendData)
            send?.start { (error) in
                if (error != nil) {
                    var errorString = "We encountered an error: "
                    errorString.append((error?.localizedDescription)!)
                    let alert = UIAlertController(title: "Failure", message: errorString, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                } 
                
            }
        let segueController = VerificationCodeViewController()
        curUser.verificationCode = passwordString
        curUser.email = emailTF.text!
        emailTF.text = "" 
        segueController.typeInt = 2
        curUser.previousController = "SetEmailViewController"
        segueController.curUser = curUser
        present(segueController, animated: true, completion: nil)
//            } else {
//            let alert = UIAlertController(title: "Failure", message: "Not from UCLA", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
    }
    func checkEmailTF(email: String) -> Bool {
        if (email.contains("g.ucla.edu") || email.contains("ucla.edu")) {
            return true
        }
        return false
        
    }
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
        backButton.setImage(UIImage(named: "arrowIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(handleBackMove), for: .touchUpInside)
        
        let titleLabel = UILabel()
        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "What's your email?"
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 32)
        titleLabel.textColor = UIColor.darkGray
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.bounds.height * 0.08).isActive = true
        
        
        self.view.addSubview(emailTF)
        emailTF.translatesAutoresizingMaskIntoConstraints = false
        emailTF.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.85).isActive = true
        emailTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTF.placeholder = "Email"
        emailTF.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16)
        emailTF.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: self.view.bounds.height * 0.02).isActive = true
        emailTF.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        emailTF.layer.backgroundColor = UIColor.white.cgColor
        emailTF.layer.borderColor = UIColor.lightGray.cgColor
        emailTF.layer.borderWidth = 1
        emailTF.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        emailTF.layer.cornerRadius = 5
        
     
        
        
        
        
        
       
        
        
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
        continueButton.addTarget(self, action: #selector(handleMoveToStudentVal), for: .touchUpInside)
     
    
    }

  

  }
