//
//  EditTimeViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 9/18/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import UIKit
import Firebase

class EditTimeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    
    let titleLabel = UILabel()
    var reminder = Reminder()
    let cell2 = UITableViewCell(style: .subtitle, reuseIdentifier: "CellID2")
    let cell3 = UITableViewCell(style: .subtitle, reuseIdentifier: "CellID3")

    var dayPicker = UIPickerView()
    var timePicker = UIDatePicker()
    var timePicker2 = UIDatePicker()
    var pickerData = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"] 
    var isChanged = false
    var isChanged2 = false
    var previousDay = String()
    var previousStartTime = String()
    var previousEndTime = String()
    var previousStartHour = Int()
    var previousStartMinute = Int()
    var previousEndHour = Int()
    var previousEndMinute = Int()
    
    let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier(rawValue: NSGregorianCalendar))
    let unitFlags: NSCalendar.Unit = [.hour, .minute]
    
    
    func updateTime() {
        
        
        let ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("Personal Reminders").child(reminder.id)
        
        let day = NSString(string: previousDay)
        let startHour = NSNumber(value: previousStartHour)
        let startMinute = NSNumber(value: previousStartMinute)
        let endHour = NSNumber(value: previousEndHour)
        let endMinute = NSNumber(value: previousEndMinute)
        
        let values = ["StartHour": startHour, "StartMinute": startMinute, "EndHour": endHour, "EndMinute": endMinute, "Day": day]
        
        ref.updateChildValues(values)
        let segueController = SetUpFreeTimeViewController()
        present(segueController, animated: true, completion: nil)
        
    }
    
    
    func changeTitleBasedOnPicker() {
        titleLabel.text = pickerView(dayPicker, titleForRow: dayPicker.selectedRow(inComponent: 0), forComponent: 0)
        previousDay = titleLabel.text!
        titleLabel.text?.append(", ")
        
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        let timeString = formatter.string(from: timePicker.date)
        previousStartTime = timeString
        
        
        let myComponents = myCalendar?.components(unitFlags, from: timePicker.date)
        
        previousStartHour = (myComponents?.hour)!
        previousStartMinute = (myComponents?.minute)!
        
        
        titleLabel.text?.append(timeString)
        titleLabel.text?.append(" to ")
        
        if (isChanged2) {
            
            if (cell3.isHidden) {
                
            titleLabel.text?.append(formatter.string(from: timePicker2.date))
            let components2 = myCalendar?.components(unitFlags, from: timePicker2.date)
            previousEndHour = (components2?.hour)!
            previousEndMinute = (components2?.minute)!
                
                
            } else {
                titleLabel.text?.append(previousEndTime)
            }
            
            
        } else {
            
        titleLabel.text?.append(reminder.timeString2)
            
        }
    }
    
    func changeTitleBasedOnPicker2() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        
        if (isChanged) {
            if (cell2.isHidden) {
            titleLabel.text = pickerView(dayPicker, titleForRow: dayPicker.selectedRow(inComponent: 0), forComponent: 0)
            previousDay = titleLabel.text!
            titleLabel.text?.append(", ")
            
            let timeString = formatter.string(from: timePicker.date)
            titleLabel.text?.append(timeString)
            let myComponents = myCalendar?.components(unitFlags, from: timePicker.date)
                
            previousStartHour = (myComponents?.hour)!
            previousStartMinute = (myComponents?.minute)!
                
        } else {
            titleLabel.text = previousDay
            titleLabel.text?.append(", ")
            titleLabel.text?.append(previousStartTime)
            }
        } else {
            titleLabel.text = reminder.day
            titleLabel.text?.append(", ")
            titleLabel.text?.append(reminder.timeString1)
        }
        titleLabel.text?.append(" to ")
      
        
        let timeString2 = formatter.string(from: timePicker2.date)
        titleLabel.text?.append(timeString2)
        previousEndTime = timeString2
        
        let components2 = myCalendar?.components(unitFlags, from: timePicker2.date)
        previousEndHour = (components2?.hour)!
        previousEndMinute = (components2?.minute)!
        
        
    
    }
    
    
    func handleEditTime() {
        cell3.isHidden = !cell3.isHidden
        isChanged2 = true
        if (cell3.isHidden) {
            changeTitleBasedOnPicker2()
        }
    }
    
    func handleEditDayAndTime() {
        cell2.isHidden = !cell2.isHidden
        isChanged = true
        if (cell2.isHidden) {
            changeTitleBasedOnPicker()
        }

        
    }
    
    
    
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

    //---------------------------------------------------------------
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 4, 7:
            return 200
        default:
            return 50
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0, 2, 5, 8:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CellID")
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            return cell
        case 1:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CellID")
            cell.selectionStyle = .none
            cell.addSubview(titleLabel)
            titleLabel.text = reminder.day
            titleLabel.text?.append(", ")
            titleLabel.text?.append(reminder.timeString1)
            titleLabel.text?.append(" to ")
            titleLabel.text?.append(reminder.timeString2)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 15).isActive = true
            titleLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
            return cell
        case 3:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CellID")
            cell.selectionStyle = .none
            let timeLabel1 = UILabel()
            cell.addSubview(timeLabel1)
            timeLabel1.translatesAutoresizingMaskIntoConstraints = false
            timeLabel1.text = "Start Day and Time"
            timeLabel1.leftAnchor.constraint(lessThanOrEqualTo: cell.leftAnchor, constant: 15).isActive = true
            timeLabel1.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            timeLabel1.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
            
            let button = UIButton()
            cell.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
            button.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
            button.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            button.addTarget(self, action: #selector(handleEditDayAndTime), for: .touchUpInside)
            
            let lineView = UIView()
            cell.addSubview(lineView)
            lineView.layer.borderColor = UIColor.gray.cgColor
            lineView.layer.borderWidth = 1
            lineView.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            lineView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            lineView.widthAnchor.constraint(equalToConstant: cell.bounds.width * 0.8).isActive = true
            
            return cell
        case 4:

            cell2.isHidden = true
            cell2.selectionStyle = .none

            cell2.addSubview(dayPicker)
            
            dayPicker.dataSource = self
            dayPicker.delegate = self

            dayPicker.translatesAutoresizingMaskIntoConstraints = false
            dayPicker.leftAnchor.constraint(equalTo: cell2.leftAnchor, constant: 5).isActive = true
            dayPicker.topAnchor.constraint(equalTo: cell2.topAnchor).isActive = true
            dayPicker.bottomAnchor.constraint(equalTo: cell2.bottomAnchor).isActive = true
            dayPicker.rightAnchor.constraint(equalTo: cell2.centerXAnchor).isActive = true
            
            cell2.addSubview(timePicker)
            timePicker.datePickerMode = .time
            timePicker.translatesAutoresizingMaskIntoConstraints = false
            timePicker.leftAnchor.constraint(equalTo: dayPicker.rightAnchor).isActive = true
            timePicker.rightAnchor.constraint(equalTo: cell2.rightAnchor, constant: -5).isActive = true
            timePicker.topAnchor.constraint(equalTo: cell2.topAnchor).isActive = true
            timePicker.bottomAnchor.constraint(equalTo: cell2.bottomAnchor).isActive = true
            return cell2
        case 6:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CellID")
            cell.selectionStyle = .none

            let timeLabel2 = UILabel()
            cell.addSubview(timeLabel2)
            timeLabel2.translatesAutoresizingMaskIntoConstraints = false
            timeLabel2.text = "End Time"
            timeLabel2.leftAnchor.constraint(lessThanOrEqualTo: cell.leftAnchor, constant: 15).isActive = true
            timeLabel2.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            timeLabel2.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
            
            let showButton = UIButton()
            cell.addSubview(showButton)
            showButton.translatesAutoresizingMaskIntoConstraints = false
            showButton.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
            showButton.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
            showButton.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            showButton.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            showButton.addTarget(self, action: #selector(handleEditTime), for: .touchUpInside)
            
            let lineView = UIView()
            cell.addSubview(lineView)
            lineView.layer.borderColor = UIColor.gray.cgColor
            lineView.layer.borderWidth = 1
            lineView.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            lineView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            lineView.widthAnchor.constraint(equalToConstant: cell.bounds.width * 0.8).isActive = true
            
            return cell
        case 7:
            
            cell3.isHidden = true
            cell3.selectionStyle = .none

            cell3.addSubview(timePicker2)
            timePicker2.datePickerMode = .time
            timePicker2.translatesAutoresizingMaskIntoConstraints = false
            timePicker2.centerXAnchor.constraint(equalTo: cell3.centerXAnchor).isActive = true
            timePicker2.widthAnchor.constraint(equalToConstant: cell3.bounds.width * 0.5).isActive = true
            timePicker2.topAnchor.constraint(equalTo: cell3.topAnchor).isActive = true
            timePicker2.bottomAnchor.constraint(equalTo: cell3.bottomAnchor).isActive = true
            
            return cell3
        default:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CellID")
            cell.selectionStyle = .none

            cell.backgroundColor = UIColor.clear
            return cell
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        previousDay = reminder.day
        previousStartHour = reminder.startHour
        previousStartMinute = reminder.startMinute
        previousEndHour = reminder.endHour
        previousEndMinute = reminder.endMinute
        
        var tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        
        let containerView = UIView()
        self.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        containerView.backgroundColor = UIColor.white
        let topTitle = UILabel()
        containerView.addSubview(topTitle)
        topTitle.translatesAutoresizingMaskIntoConstraints = false
        topTitle.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        topTitle.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        topTitle.text = "Details"
        topTitle.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 10).isActive = true
        
        let editButton = UIButton()
        containerView.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        editButton.setTitle("Done", for: .normal)
        editButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
        editButton.setTitleColor(UIColor.blue, for: .normal)
        editButton.addTarget(self, action: #selector(updateTime) , for: .touchUpInside)
        
        
        
        
        
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
