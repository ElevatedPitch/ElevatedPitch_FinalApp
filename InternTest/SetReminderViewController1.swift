//
//  ReminderViewController.swift
//  
//
//  Created by Rahul Sheth on 7/12/17.
//
//

import Foundation
import Firebase
import UIKit
import EventKit
//Set up personal reminders that a student can send to a Recruiter


class SetReminderViewController1: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //INITIALIZATION OF VARIABLES 
    
    
    var dayPicker = UIPickerView()
    var timePicker2 = UIDatePicker()
    var pickerData = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    //-------------------------------------------------------------------------------------------
    //HELPER FUNCTIONS AND VIEW DID LOAD 
    
    //Basically the change the date according to the picker view
    
    func moveToReminder2() {
        //Extract the date
        
        let dayString = pickerView(dayPicker, titleForRow: dayPicker.selectedRow(inComponent: 0), forComponent: 0)
        
        let passDate = timePicker2.date
        
        
        let segueController = SetReminderViewController2(nibName: nil, bundle: nil)
        
        segueController.startDay = dayString
        segueController.startTime = passDate
        present(segueController, animated: true, completion: nil)
    }
    
    func handleBackMove() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
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
        titleLabel.text = "Set Start Date"
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 32)
        titleLabel.textColor = UIColor.darkGray
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.bounds.height * 0.08).isActive = true
        
        let descriptionLabel = UILabel()
        self.view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        descriptionLabel.text = "Specify a time frame a recruiter can contact you. Please choose a time you're free every week."
        descriptionLabel.textAlignment = .center
        descriptionLabel.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.70).isActive = true
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        
//        
//        self.view.addSubview(timePicker)
//        timePicker.translatesAutoresizingMaskIntoConstraints = false
//        timePicker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60).isActive = true
//        timePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        timePicker.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 2 / 5).isActive  = true
//        timePicker.datePickerMode = .time
        
        
        
        self.view.addSubview(timePicker2)
        timePicker2.translatesAutoresizingMaskIntoConstraints = false
        timePicker2.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        timePicker2.leftAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        timePicker2.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        timePicker2.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 2 / 5).isActive = true
        timePicker2.datePickerMode = .time

        self.view.addSubview(dayPicker)
        dayPicker.translatesAutoresizingMaskIntoConstraints = false
        dayPicker.dataSource = self
        dayPicker.delegate = self
        dayPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        dayPicker.rightAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        dayPicker.topAnchor.constraint(equalTo: timePicker2.topAnchor).isActive = true
        dayPicker.bottomAnchor.constraint(equalTo: timePicker2.bottomAnchor).isActive = true
        
        
        
        let continueButton = UIButton()
        self.view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.65).isActive = true
        continueButton.topAnchor.constraint(equalTo: dayPicker.bottomAnchor, constant: 30).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.layer.cornerRadius = 10
        continueButton.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
        continueButton.addTarget(self, action: #selector(moveToReminder2), for: .touchUpInside)
        
        
        
        
        self.view.backgroundColor = UIColor.white
    }
    

    
    
    //-------------------------------------------------------------------------------------------
    
    //Set up picker View 
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    
    
    
    
    
    
}
