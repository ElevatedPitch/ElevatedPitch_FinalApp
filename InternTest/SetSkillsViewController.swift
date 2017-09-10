//
//  SetSkillsViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 8/14/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import UIKit
import Firebase

class SetSkillsViewController: UIViewController {

    let titleLabel = UILabel()
    let continueButton = UIButton()
    let backButton = UIButton()
    let skillTitle1 = UILabel()
    let skillTextField1 = UITextField()
    let skillTitle2 = UILabel()
    let skillTextField2 = UITextField()
    let skillTitle3 = UILabel()
    let skillTextField3 = UITextField()
    let skillTitle4 = UILabel()
    let skillTextField4 = UITextField()
    
    

    
    func moveToProfile() {
        let segueController = ProfilePageViewController()
        present(segueController, animated: true, completion: nil)
    }
    func uploadToFirebase() {
        let ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
        var value = [String: AnyObject]()
        var uploadString = String()
        if (skillTextField1.hasText) {
            uploadString = "#"
            uploadString.append(skillTextField1.text!)
            var firebaseString = NSString(string: uploadString)
            value.updateValue(firebaseString, forKey: "Skill 1")
        }
        if (skillTextField2.hasText) {
            
            uploadString = "#"
            uploadString.append(skillTextField2.text!)
            var firebaseString = NSString(string: uploadString)
            value.updateValue(firebaseString, forKey: "Skill 2")
        }
        if (skillTextField3.hasText) {
            
            uploadString = "#"
            uploadString.append(skillTextField3.text!)
            var firebaseString = NSString(string: uploadString)
            value.updateValue(firebaseString, forKey: "Skill 3")
        }
        if (skillTextField4.hasText) {
            
            uploadString = "#"
            uploadString.append(skillTextField4.text!)
            var firebaseString = NSString(string: uploadString)
            value.updateValue(firebaseString, forKey: "Skill 4")
        }
        ref.updateChildValues(value)
        moveToProfile()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
       
        
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(skillTitle1)
        skillTitle1.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(skillTitle2)
        skillTitle2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(skillTitle3)
        skillTitle3.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(skillTitle4)
        skillTitle4.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(skillTextField1)
        skillTextField1.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(skillTextField2)
        skillTextField2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(skillTextField3)
        skillTextField3.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(skillTextField4)
        skillTextField4.translatesAutoresizingMaskIntoConstraints = false
        
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
        backButton.addTarget(self, action: #selector(moveToProfile), for: .touchUpInside)
        
        titleLabel.text = "Set your skills"
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 32)
        titleLabel.textColor = UIColor.black
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.bounds.height * 0.08).isActive = true

        skillTitle1.text = "Skill 1"
        skillTitle1.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: -20).isActive = true
        skillTitle2.text = "Skill 2"
        skillTitle2.leftAnchor.constraint(equalTo: skillTitle1.leftAnchor).isActive = true
        skillTitle3.text = "Skill 3"
        skillTitle3.leftAnchor.constraint(equalTo: skillTitle1.leftAnchor).isActive = true
        skillTitle4.text = "Skill 4"
        skillTitle4.leftAnchor.constraint(equalTo: skillTitle1.leftAnchor).isActive = true
        
        skillTitle1.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        skillTitle2.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        skillTitle3.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        skillTitle4.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        
        skillTextField1.heightAnchor.constraint(equalToConstant: 25).isActive = true
        skillTextField2.heightAnchor.constraint(equalTo: skillTextField1.heightAnchor).isActive = true
        skillTextField3.heightAnchor.constraint(equalTo: skillTextField1.heightAnchor).isActive = true
        skillTextField4.heightAnchor.constraint(equalTo: skillTextField1.heightAnchor).isActive = true
        
        skillTextField1.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.3).isActive = true
        skillTextField2.widthAnchor.constraint(equalTo: skillTextField1.widthAnchor).isActive = true
        skillTextField3.widthAnchor.constraint(equalTo: skillTextField1.widthAnchor).isActive = true
        skillTextField4.widthAnchor.constraint(equalTo: skillTextField1.widthAnchor).isActive = true
        
        
        
        let height = (self.view.bounds.height * 0.45) - ((self.view.bounds.height * 0.08 + 40) + self.view.bounds.height * 0.05)
        
        
        skillTextField1.centerYAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: height / 5).isActive = true
        skillTextField1.leftAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        skillTextField1.layer.borderWidth = 0.5
        skillTextField1.layer.borderColor = UIColor.darkGray.cgColor
        skillTextField1.layer.cornerRadius = 3
        
        skillTextField2.centerYAnchor.constraint(equalTo: skillTextField1.bottomAnchor, constant: height / 5).isActive = true
        skillTextField2.leftAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        skillTextField2.layer.borderWidth = 0.5
        skillTextField2.layer.borderColor = UIColor.darkGray.cgColor
        skillTextField2.layer.cornerRadius = 3
        
        skillTextField3.centerYAnchor.constraint(equalTo: skillTextField2.bottomAnchor, constant: height / 5).isActive = true
        skillTextField3.leftAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        skillTextField3.layer.borderWidth = 0.5
        skillTextField3.layer.borderColor = UIColor.darkGray.cgColor
        skillTextField3.layer.cornerRadius = 3
        
        skillTextField4.centerYAnchor.constraint(equalTo: skillTextField3.bottomAnchor, constant: height / 5).isActive = true
        skillTextField4.leftAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        skillTextField4.layer.borderWidth = 0.5
        skillTextField4.layer.borderColor = UIColor.darkGray.cgColor
        skillTextField4.layer.cornerRadius = 3
        
        
        skillTitle1.centerYAnchor.constraint(equalTo: skillTextField1.centerYAnchor).isActive = true
        skillTitle2.centerYAnchor.constraint(equalTo: skillTextField2.centerYAnchor).isActive = true
        skillTitle3.centerYAnchor.constraint(equalTo: skillTextField3.centerYAnchor).isActive = true
        skillTitle4.centerYAnchor.constraint(equalTo: skillTextField4.centerYAnchor).isActive = true
        
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
