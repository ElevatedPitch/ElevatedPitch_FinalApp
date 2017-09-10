//
//  SetBioViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 8/14/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class SetPositionViewController: UIViewController, UITextViewDelegate {
    
    let titleLabel = UILabel()
    let bioTextField = UITextView()
    let backButton = UIButton()
    let continueButton = UIButton()
    let textFieldLabel = UILabel()
    var typeInt: UInt? 
    var textField = UITextField()
    func moveToProfile() {
        let segueController = ProfilePageViewController()
        present(segueController, animated: true, completion: nil)
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if bioTextField.textColor == UIColor.lightGray {
            bioTextField.text = ""
            bioTextField.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return numberOfChars < 250
    }
    func uploadToDatabase() {
        let ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
        var value = [String:AnyObject]()
        if textField.text != "" {
            var firebaseString = NSString(string: (textField.text)!)
            value.updateValue(firebaseString, forKey: titleLabel.text!)
        }
        if bioTextField.text != "" {
            var firebaseString = (NSString(string: (bioTextField.text)))
            titleLabel.text?.append(" Description")
            value.updateValue(firebaseString, forKey: titleLabel.text!)
            
        }
        ref.updateChildValues(value)
        let segueController = ProfilePageViewController()
        present(segueController, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(bioTextField)
        self.view.addSubview(backButton)
        self.view.addSubview(continueButton)
        self.view.addSubview(textField)
        self.view.backgroundColor = UIColor.white
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.setImage(UIImage(named: "arrowIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(moveToProfile), for: .touchUpInside)
        
        
        switch typeInt! {
        case 1:
            titleLabel.text = "Position 1"
            
            break
        case 2:
            titleLabel.text = "Position 2"
            break
        default:
            titleLabel.text = "Position 3"
            break
        
        }
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 26)
        titleLabel.textColor = UIColor.darkGray
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.bounds.height * 0.08).isActive = true
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerYAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: self.view.bounds.height * 0.06).isActive = true
        textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        textField.placeholder = "Job Title..."
        textField.backgroundColor = UIColor.white
        textField.layer.borderWidth = 0.5
        textField.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.55).isActive = true
        textField.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        bioTextField.translatesAutoresizingMaskIntoConstraints = false
        bioTextField.delegate = self
        bioTextField.layer.borderWidth = 0.5
        bioTextField.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.15).isActive = true
        bioTextField.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.65).isActive = true
        bioTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bioTextField.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -20).isActive = true
        bioTextField.text = "Job Description for a position students can contact you for (250 Chars Max)..."
        bioTextField.textColor = UIColor.lightGray
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.65).isActive = true
        continueButton.topAnchor.constraint(equalTo: view.topAnchor, constant: self.view.bounds.height * 0.45).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.layer.cornerRadius = 10
        continueButton.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
        continueButton.addTarget(self, action: #selector(uploadToDatabase), for: .touchUpInside)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)
        
        
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
