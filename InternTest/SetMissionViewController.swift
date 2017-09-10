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
class SetMissionViewController: UIViewController, UITextViewDelegate {
    
    let titleLabel = UILabel()
    let bioTextField = UITextView()
    let backButton = UIButton()
    let continueButton = UIButton()
    let textFieldLabel = UILabel()
    
    
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
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if bioTextField.text.isEmpty {
            textFieldLabel.text = "Please enter a short (175-Character Max) bio..."
            textFieldLabel.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return numberOfChars < 175
    }
    func uploadToDatabase() {
        let ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
        var value = [String:AnyObject]()
        if bioTextField.text != nil {
            var firebaseString = NSString(string: bioTextField.text)
            value.updateValue(firebaseString, forKey: "Company Mission")
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
        
        self.view.backgroundColor = UIColor.white
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.setImage(UIImage(named: "arrowIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(moveToProfile), for: .touchUpInside)
        
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Company Mission"
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 26)
        titleLabel.textColor = UIColor.darkGray
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.bounds.height * 0.08).isActive = true
        
        
        bioTextField.translatesAutoresizingMaskIntoConstraints = false
        bioTextField.delegate = self
        bioTextField.layer.borderWidth = 0.5
        bioTextField.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.15).isActive = true
        bioTextField.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.65).isActive = true
        bioTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bioTextField.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -20).isActive = true
        bioTextField.text = "Set your company's mission (175 chars)..."
        bioTextField.textColor = UIColor.lightGray
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
        continueButton.addTarget(self, action: #selector(uploadToDatabase), for: .touchUpInside)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)
        
        
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
