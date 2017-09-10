//
//  SetReminderViewController2.swift
//  InternTest
//
//  Created by Rahul Sheth on 8/18/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import UIKit
import Firebase

class SetReminderViewController2: UIViewController {

    
    var timePicker = UIDatePicker()

    var startDay: String?
    var startTime: Date?
    
    
    
    func changeDate() {
        
        
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier(rawValue: NSGregorianCalendar))
        let unitFlags: NSCalendar.Unit = [.hour, .minute]
        let myComponents = myCalendar?.components(unitFlags, from: startTime!)
        let myComponents2 = myCalendar?.components(unitFlags , from: timePicker.date)
        
        
        let hour1 = myComponents?.hour
        let minute1 = myComponents?.minute
        let hour2 = myComponents2?.hour
        let minute2 = myComponents2?.minute
        let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference().child("users").child(uid!).child("Personal Reminders").childByAutoId()
        let startHour = NSNumber(value: hour1!)
        let startMinute = NSNumber(value: minute1!)
        let endHour = NSNumber(value: hour2!)
        let endMinute = NSNumber(value: minute2!)
        
        let dayString = startDay
        
        let values = ["StartHour": startHour, "StartMinute": startMinute, "EndHour": endHour, "EndMinute": endMinute, "Day": NSString(string: dayString!)]
        ref.setValue(values)
        
        
        let segueController = SetUpFreeTimeViewController()
        present(segueController, animated: true, completion: nil)
    }
    
    func handleBackMove() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
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

        self.view.backgroundColor = UIColor.white
        
        let titleLabel = UILabel()
        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Set End Time"
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 32)
        titleLabel.textColor = UIColor.darkGray
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.bounds.height * 0.08).isActive = true
        
        
        
                self.view.addSubview(timePicker)
                timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
                timePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                timePicker.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 2 / 5).isActive  = true
                timePicker.datePickerMode = .time
        
        
        
        let continueButton = UIButton()
        self.view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.65).isActive = true
        continueButton.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 30).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        continueButton.setTitle("Add Date", for: .normal)
        continueButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.layer.cornerRadius = 10
        continueButton.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
        continueButton.addTarget(self, action: #selector(changeDate), for: .touchUpInside)
        
        
        
        

        
        
        

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
