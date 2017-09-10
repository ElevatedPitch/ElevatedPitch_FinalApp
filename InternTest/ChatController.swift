//
//  ChatController.swift
//  InternTest
//
//  Created by Rahul Sheth on 1/18/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import Foundation
import UIKit
import Firebase


// This is where you message people
class ChatController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
   // Offset by 20 pixels vertically to take the status bar into account
    
    //Initialization of variables
   let cellIdentifier = "CellID"
    var tableView = UITableView()
    var nameString = String()
    var profileImageURLString = String()
    var messagesArray = [Messages]()
    var mutableString = NSAttributedString()
    let newItem = UINavigationItem()
    let messageTF = UITextView()
    let newLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    let containerView = UIView()

    
    //Set the title Label on the top of the view Controller
    var  user : User?  {
        didSet {
            
            let label = UILabel()
            label.text = user?.name
            label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
            label.textColor = UIColor.white
            self.view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
        }
    }
    
    //Required when using the didSet property. (not advisable. If you wanna pass in values just pass it through from the previous view controller
    init(user: User) {
        super.init(nibName: nil, bundle: nil)

        ({ self.user = user })()


    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        var frame = textView.frame
        frame.size.height = textView.contentSize.height
        textView.frame = frame
        
        containerView.heightAnchor.constraint(equalTo: textView.heightAnchor).isActive = true
    }
    
    //----------------------------------
   
  //HELPER FUNCTIONS AND VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.view.backgroundColor = UIColor(red: (0/255.0), green: (204/255.0), blue: (255/255.0), alpha: 1)
        let gradientLayer = CAGradientLayer()
        let topColor = UIColor(red: (107/255.0), green: (202/255.0), blue: (253/255.0), alpha: 1 )
        let bottomColor = UIColor(red: (105/255.0), green: (160/255.0), blue: (252/255.0), alpha: 0.7 )
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 60)
        view.layer.addSublayer(gradientLayer)
        
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        fetchMessages()
        setUpInput()
        retrieveCurrentNameAndURL()
        
        tableView.dataSource = self
        tableView.delegate = self

        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        
        view.addGestureRecognizer(tap)
        
    }

  
   //show the current person's name and profileImage URL. This is there so that when we send notifications to the other user that they got a message, they will have the current profileImage and name
    func retrieveCurrentNameAndURL() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference().child("users").child(uid!)
        ref.observe(.value, with:  { (snapshot) in
            
            let dictionary = snapshot.value as? [String: AnyObject]
            if (dictionary?["name"] as? String != nil) {
                self.nameString = dictionary?["name"] as! String
            }
            if (dictionary?["profileImageURL"] as? String != nil) {
                self.profileImageURLString = dictionary?["profileImageURL"] as! String
            }
            
        })
    }
    
    
    //Retrieve all of the messages to display
    func fetchMessages() {
        messagesArray.removeAll()
        let sendingID = (FIRAuth.auth()?.currentUser?.uid)! as NSString
        let receivingID = NSString(string: (user?.uid)!)
        let ref = FIRDatabase.database().reference().child("messages")
        ref.observe(.childAdded, with: {  (snapshot) in
            if let dictionary = snapshot.value as?  [String: AnyObject] {
                let message = Messages()

                if (dictionary["ReceivingID"] as! NSString == receivingID && dictionary["SendingID"] as! NSString == sendingID) {
                    message.message = dictionary["message"] as! String?
                    message.length = (message.message?.characters.count)! * 5 + 10
                    
                    message.height = message.length / 5
                    message.ReceivingID = receivingID as String
                    message.SendingID = sendingID as String
                    message.type = 1
                    self.messagesArray.append(message)
                    
                    
                    
                } else if (dictionary["ReceivingID"] as! NSString == sendingID && dictionary["SendingID"] as! NSString == receivingID) {
                    message.message = dictionary["message"] as! String?
                    message.ReceivingID = sendingID as String
                    message.SendingID = receivingID as String
                    message.type = 2
                    self.messagesArray.append(message)
                    
                    
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    

                }
                DispatchQueue.main.async {
                    if (self.tableView.contentSize.height > self.tableView.frame.size.height) {
                        self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.size.height), animated: false)
                    }
                }
                
            }
        })

        
    }
    
    //Return to NotificationCenterViewController
       func handleReturnToMessages() {
       
        present((self.user?.previousController)!, animated: true, completion: nil)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    //set up all of your background like nav bar, etc etc
    func setUpInput() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let arrowIcon = UIButton()
        self.view.addSubview(arrowIcon)
        let arrowImage = UIImage(named: "arrowIcon")
        let arrowTinted = arrowImage?.withRenderingMode(.alwaysTemplate)
        arrowIcon.translatesAutoresizingMaskIntoConstraints = false
        arrowIcon.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
        arrowIcon.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        arrowIcon.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        arrowIcon.widthAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        arrowIcon.setImage(arrowTinted, for: .normal)
        arrowIcon.tintColor = UIColor.white
        arrowIcon.addTarget(self, action: #selector(handleReturnToMessages), for: .touchUpInside)
        
        
        containerView.backgroundColor = UIColor.white
        
        let sendButton = UIButton()
        self.view.addSubview(containerView)
        containerView.addSubview(sendButton)
        containerView.addSubview(messageTF)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        containerView.layer.borderWidth = CGFloat(1.0)
        containerView.layer.borderColor = UIColor.black.cgColor
        
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5).isActive = true
        sendButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10 ).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.setTitle("Send", for: .normal)
         
        sendButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        sendButton.layer.cornerRadius = 5
        sendButton.backgroundColor = UIColor(red: (0/255.0), green: (153/255.0), blue: (204/255.0), alpha: 1 )
        
        messageTF.layer.cornerRadius = 5
        messageTF.translatesAutoresizingMaskIntoConstraints = false
        messageTF.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        messageTF.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4).isActive = true
        messageTF.heightAnchor.constraint(equalToConstant: containerView.frame.height / 3).isActive = true
        messageTF.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        messageTF.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -5).isActive = true
        messageTF.backgroundColor = UIColor.white
        messageTF.layer.borderWidth = CGFloat(1.0)
        messageTF.layer.borderColor = UIColor.gray.cgColor
        messageTF.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        sendButton.leftAnchor.constraint(equalTo: messageTF.rightAnchor, constant: 5).isActive = true
        
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.bottomAnchor.constraint(equalTo: (messageTF.topAnchor)).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 45).isActive = true
    }
    
    var timeStamp: TimeInterval {
        return NSDate().timeIntervalSince1970 * 1000
    }
    
    
    //Submit a message and upload to the database 
    func handleSubmit() {
        if messageTF.text != "" {
        let sendingID = (FIRAuth.auth()?.currentUser?.uid)! as NSString
        let receivingID = NSString(string: (user?.uid)!)
        let ref = FIRDatabase.database().reference().child("messages").childByAutoId()
        
        let message: NSString = NSString(string: messageTF.text!)
        
        
        let timestamp = 0 - timeStamp
        
        let values = ["message": message, "SendingID": sendingID as AnyObject, "ReceivingID": receivingID, "timeStamp": timestamp as AnyObject] as [String: AnyObject]
        ref.updateChildValues(values)
        let ref3updateValue = ["Last Message": message, "Sending Name": sendingID, "Read": "False" as AnyObject, "timeStamp": timestamp as AnyObject] as [String : AnyObject]

        let ref3 = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("friends").child((user?.uid)!)
        let ref4 = FIRDatabase.database().reference().child("users").child((user?.uid)!).child("friends").child((FIRAuth.auth()?.currentUser?.uid)!)
        ref3.setValue(ref3updateValue)
        ref4.setValue(ref3updateValue)
        let ref2 = FIRDatabase.database().reference().child("users").child((user?.uid)!).child("Notifications").childByAutoId()
        var string = globalCurrentName
        string.append(" sent you a message")
        let messageString = string as NSString
        let typeString = "Message" as NSString
        let imageURLString = globalProfilePictureImageURL
        let readString = "false"
        let value = ["Message": messageString, "OtherUID": sendingID, "Type": typeString,  "profileImageURL": imageURLString as NSString, "name": self.nameString as NSString, "read": readString as NSString] as [String : AnyObject]
        ref2.updateChildValues(value)
        messageTF.text = nil
            
        
            
        }
        
        
    }



   //------------------------------
    //Don't modify

    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    
    //-------------------------------
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 200
        if let text = messagesArray[indexPath.row].message {
            height = estimateHeightForString(text: text).height
        }
        return height + 15
        
    }
    
    func estimateHeightForString(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17)], context: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellLabel = UILabel()
        let containerView = UIView()
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        cell.isUserInteractionEnabled = false
        
        cell.backgroundColor = UIColor.white
        let bubbleView = UIView()
        cell.addSubview(bubbleView)
        bubbleView.addSubview(cellLabel)
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.layer.cornerRadius = 10
        bubbleView.layer.masksToBounds = true
        
        bubbleView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        bubbleView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 5).isActive = true
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        cellLabel.text = messagesArray[indexPath.row].message
        cellLabel.backgroundColor = UIColor.clear
        cellLabel.font = cellLabel.font.withSize(17)
        cellLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 5).isActive = true
        
        cellLabel.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 5).isActive = true
        
        cellLabel.lineBreakMode = .byWordWrapping
        cellLabel.numberOfLines = 0
        var width = estimateHeightForString(text: messagesArray[indexPath.row].message!).width + 25
        bubbleView.widthAnchor.constraint(equalToConstant: width).isActive = true
        cellLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        if (messagesArray[indexPath.row].type == 1) {
            bubbleView.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -5 ).isActive = true
            bubbleView.backgroundColor = UIColor(red: 41/255 , green: 147/255 , blue: 245/255 , alpha: 1)
            cellLabel.textColor = UIColor.white
            cellLabel.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -5 ).isActive = true
            
        }
        
        if (messagesArray[indexPath.row].type == 2) {
            bubbleView.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
            bubbleView.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 1)

        }
        return cell
    }

    
}

    //------------------------------------------------------------------------
    
   
