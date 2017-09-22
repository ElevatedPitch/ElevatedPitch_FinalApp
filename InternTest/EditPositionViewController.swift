//
//  EditPositionViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 9/21/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import UIKit
import Firebase
class EditPositionViewController: UIViewController {

    
    let titleLabel = UILabel()
    let positionLabel = UILabel()
    let institutionLabel = UILabel()
    
    let positionTF = UITextField()
    let institutionTF = UITextField()
    var backButton = UIButton()
    
    var positionString = String()
    var institutionString = String()
    
    var continueButton = UIButton()
    
    func moveBack() {
        dismiss(animated: true, completion: nil)
    }
    
    
    func uploadToFirebase() {
        let ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
        let position = NSString(string: positionTF.text!)
        let institution = NSString(string: institutionTF.text!)
        
        let value = [positionString: position, institutionString: institution]
        ref.updateChildValues(value)
        positionTF.text = ""
        institutionTF.text = ""
        let segueController = ProfilePageViewController()
        present(segueController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
                super.viewDidLoad()
                
                self.view.addSubview(titleLabel)
                titleLabel.translatesAutoresizingMaskIntoConstraints = false
                
                self.view.addSubview(continueButton)
                continueButton.translatesAutoresizingMaskIntoConstraints = false
                
                
                self.view.addSubview(backButton)
                backButton.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(positionLabel)
                positionLabel.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(institutionLabel)
                institutionLabel.translatesAutoresizingMaskIntoConstraints = false
              
                self.view.addSubview(positionTF)
                positionTF.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(institutionTF)
                institutionTF.translatesAutoresizingMaskIntoConstraints = false
               
                continueButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                continueButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.65).isActive = true
                continueButton.topAnchor.constraint(equalTo: view.topAnchor, constant: self.view.bounds.height * 0.45).isActive = true
                continueButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
                continueButton.setTitle("Continue", for: .normal)
                continueButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
                continueButton.setTitleColor(UIColor.white, for: .normal)
                continueButton.layer.cornerRadius = 10
                continueButton.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
                continueButton.addTarget(self, action: #selector(uploadToFirebase), for: .touchUpInside)
        
                
                self.view.backgroundColor = UIColor.white
                backButton.translatesAutoresizingMaskIntoConstraints = false
                backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
                backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
                backButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
                backButton.widthAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
                backButton.setImage(UIImage(named: "arrowIcon"), for: .normal)
                backButton.addTarget(self, action: #selector(moveBack), for: .touchUpInside)
                
                if (globalFeedString == "Employer") {
                titleLabel.text = "Major and University"
                    positionLabel.text = "Major"
                    institutionLabel.text = "University"
                    positionString = "Major"
                    institutionString = "Unversity"


                } else {
                    positionLabel.text = "Position"
                    positionString = "Position"
                    institutionLabel.text = "Company"
                    institutionString = "Company"
                    titleLabel.text = "Company and Position"
                }
                titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 32)
                titleLabel.textColor = UIColor.black
                titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.bounds.height * 0.08).isActive = true
                
                positionLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: -20).isActive = true
                institutionLabel.leftAnchor.constraint(equalTo: positionLabel.leftAnchor).isActive = true

                positionLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
                institutionLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
               
                positionTF.heightAnchor.constraint(equalToConstant: 25).isActive = true
                institutionTF.heightAnchor.constraint(equalTo: positionTF.heightAnchor).isActive = true
               
                positionTF.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.3).isActive = true
                institutionTF.widthAnchor.constraint(equalTo: positionTF.widthAnchor).isActive = true
                
                
                let height = (self.view.bounds.height * 0.45) - ((self.view.bounds.height * 0.08 + 40) + self.view.bounds.height * 0.05)
                
                
                positionTF.centerYAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: height / 5).isActive = true
                positionTF.leftAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                positionTF.layer.borderWidth = 0.5
                positionTF.layer.borderColor = UIColor.darkGray.cgColor
                positionTF.layer.cornerRadius = 3
                
                institutionTF.centerYAnchor.constraint(equalTo: positionTF.bottomAnchor, constant: height / 5).isActive = true
                institutionTF.leftAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                institutionTF.layer.borderWidth = 0.5
                institutionTF.layer.borderColor = UIColor.darkGray.cgColor
                institutionTF.layer.cornerRadius = 3
                
                positionLabel.centerYAnchor.constraint(equalTo: positionTF.centerYAnchor).isActive = true
                institutionLabel.centerYAnchor.constraint(equalTo: institutionTF.centerYAnchor).isActive = true
                
                
                // Do any additional setup after loading the view.
        }

        // Do any additional setup after loading the view.
    

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
