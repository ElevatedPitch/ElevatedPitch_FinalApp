//
//  ViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 12/21/16.
//  Copyright © 2016 Rahul Sheth. All rights reserved.
//

import UIKit
import Firebase

//This is where an Employer chooses their position


class VerificationCodeViewController: UIViewController {
    
   
    //INITIALIZATION OF VARIABLES 
    
    let companyLabel = UILabel()
    let employeeTitleLabel = UILabel()
    let companyTF = UITextField()
    let employeeTitleTF = UITextField()
    let submitButton = UIButton()
    
    var typeInt: Int?
    let titleLabel = UILabel()
    let disclaimerLabel = UILabel()
    let firstNameTF = UITextField()
    var curUser = SignUpUser()
    var previousController: UIViewController?
    //-------------------------------------------------------------------------------------------

    
    //HELPER FUNCTIONS AND VIEWDIDLOAD
    
    
   
   
    
    func handleBackMove() {
        dismiss(animated: true, completion: nil)
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
    
    
    
    func sendEmail() {
    
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
    builder.header.to = [MCOAddress(displayName: curUser.name, mailbox: curUser.email)]
    builder.header.from = MCOAddress(displayName: "Elevated Pitch", mailbox: "elevatedpitchhelp@gmail.com")
    builder.header.subject = "Invitation to Elevated Pitch"
    builder.htmlBody = "Welcome to Elevated Pitch! We've been expecting you! Here is your new verification code: "
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
    }
    
    
    
    func handleMoveToPassword() {
        
        if (firstNameTF.text?.lowercased() == curUser.verificationCode.lowercased()) {
        let segueController = SetPasswordViewController()
            segueController.curUser = self.curUser
            firstNameTF.text = ""
        present(segueController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Failure", message: "Incorrect verification code", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        
            

        }
    }
    
    //Recruiter set up is type 1
    func setUpInput1() {
        titleLabel.text = "Recruiter Sign Up"

        let disclaimerLabel2 = UILabel()
        self.view.addSubview(disclaimerLabel2)
        disclaimerLabel2.translatesAutoresizingMaskIntoConstraints = false
        disclaimerLabel2.text = "Recruiters are currently invite only"
        disclaimerLabel2.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 15)
        disclaimerLabel2.heightAnchor.constraint(equalToConstant: 15).isActive = true
        disclaimerLabel2.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: self.view.bounds.height * 0.05).isActive = true
        disclaimerLabel2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let disclaimerLabel3 = UILabel()
        self.view.addSubview(disclaimerLabel3)
        disclaimerLabel3.translatesAutoresizingMaskIntoConstraints = false
        disclaimerLabel3.text = "Contact us through our website for more information!"
        disclaimerLabel3.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 15)
        disclaimerLabel3.heightAnchor.constraint(equalToConstant: 15).isActive = true
        disclaimerLabel3.topAnchor.constraint(equalTo: disclaimerLabel2.bottomAnchor).isActive = true
        disclaimerLabel3.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
    }
    //Student set up is type 2
    func setUpInput2 () {
        
        titleLabel.text = "Please enter verification code"

        self.view.addSubview(firstNameTF)
        firstNameTF.translatesAutoresizingMaskIntoConstraints = false
        firstNameTF.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.85).isActive = true
        firstNameTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        firstNameTF.placeholder = "Code"
        firstNameTF.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16)
        firstNameTF.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: self.view.bounds.height * 0.02).isActive = true
        firstNameTF.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        firstNameTF.layer.backgroundColor = UIColor.white.cgColor
        firstNameTF.layer.borderColor = UIColor.lightGray.cgColor
        firstNameTF.layer.borderWidth = 1
        firstNameTF.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        firstNameTF.layer.cornerRadius = 5
        
        self.view.addSubview(disclaimerLabel)
        disclaimerLabel.translatesAutoresizingMaskIntoConstraints = false
        disclaimerLabel.text = "Check email for code"
        disclaimerLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        disclaimerLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        disclaimerLabel.topAnchor.constraint(equalTo: firstNameTF.bottomAnchor).isActive = true
        disclaimerLabel.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 15)

        let disclaimerLabel2 = UILabel()
        self.view.addSubview(disclaimerLabel2)
        disclaimerLabel2.translatesAutoresizingMaskIntoConstraints = false
        disclaimerLabel2.text = "No email after 5 minutes? "
        disclaimerLabel2.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 15)
        disclaimerLabel2.heightAnchor.constraint(equalToConstant: 25).isActive = true
        disclaimerLabel2.topAnchor.constraint(equalTo: disclaimerLabel.bottomAnchor).isActive = true
        disclaimerLabel2.rightAnchor.constraint(equalTo: disclaimerLabel.rightAnchor, constant: -1).isActive = true
        
        let resendButton = UIButton()
        self.view.addSubview(resendButton)
        resendButton.translatesAutoresizingMaskIntoConstraints = false
        resendButton.topAnchor.constraint(equalTo: disclaimerLabel2.topAnchor).isActive = true
        resendButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        resendButton.leftAnchor.constraint(equalTo: disclaimerLabel2.rightAnchor).isActive = true
        resendButton.setTitle(" Resend", for: .normal)
        resendButton.setTitleColor(UIColor(red: 100/255, green: 149/255, blue: 245/255, alpha: 1), for: .normal)
        resendButton.titleLabel?.font =  UIFont(name: "AppleSDGothicNeo-Bold" , size: 15)
        resendButton.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
        
        let continueButton = UIButton()
        self.view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
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
        continueButton.addTarget(self, action: #selector(handleMoveToPassword), for: .touchUpInside)

        
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
        
        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 26)
        titleLabel.textColor = UIColor.darkGray
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.bounds.height * 0.08).isActive = true
        
        
        
        

        
        
        

        if (typeInt == 1) {
            setUpInput1()
        } else {
            setUpInput2()
        }
        
        
      
       
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        
        view.addGestureRecognizer(tap)
        super.viewDidLoad()
        
        
    }
    
   
    func dismissKeyboard() {
        view.endEditing(true)
    }
   
    
    
    
}

