//
//  CameraChooseViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 2/11/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import Foundation
import UIKit
import Firebase

//Choose a profile Picture

class CameraChooseViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    //INITIALIZATON OF VARIABLES
    let Camerabutton = UIButton()
    let MoveOnButton = UIButton()
    let profilePictureImageView = UIImageView()
    let TitleTF = UITextField()
    
    
    //-------------------------------------------------------------------------------------------
    
    //HELPER FUNCTIONS AND VIEWDIDLOAD
    
    
    //pick your profile picture
    func handleSelectProfileImageView() {
        
     
    }
    
    
    
    
    
    //resize image based on the ratio to upload 
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        
        
        let widthRatio = targetSize.width / image.size.width
        let heightRatio = targetSize.height / image.size.height
        var newSize = CGSize()
        if (widthRatio > heightRatio) {
             newSize = CGSize(width: image.size.width * heightRatio, height: image.size.height * heightRatio)
        } else {
            newSize = CGSize(width: image.size.width * widthRatio, height: image.size.height * heightRatio)
        }
       
        UIGraphicsBeginImageContext(CGSize(width: newSize.width, height: newSize.height))
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    //Pick the image
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var pickedImageFromPicker = UIImage()
        if let editedImage = info["UIImagePickerControllerEditedImage"] {
            pickedImageFromPicker = editedImage as! UIImage
            dismiss(animated: true, completion: nil)
            
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            pickedImageFromPicker = originalImage as! UIImage
            dismiss(animated: true, completion: nil)
            
        }
        
        let someImage = pickedImageFromPicker.jpeg(.lowest)
    
        profilePictureImageView.image = UIImage(data: someImage!)
        profilePictureImageView.image = resizeImage(image: profilePictureImageView.image!, targetSize: CGSize(width: 130, height: 130))
        print("This is the new width", profilePictureImageView.image?.size.width)
    
        print("This is the new height", profilePictureImageView.image?.size.height)
    }
    
    
    //Place the image found in picker into the database
    func uploadIntoDatabase() {
        let imageName = NSUUID().uuidString
        
        let storageRef = FIRStorage.storage().reference().child("\(imageName).jpg")
        
        if let uploadData = UIImageJPEGRepresentation(self.profilePictureImageView.image!, 0.05) {
            storageRef.put(uploadData, metadata: nil, completion: {(metadata, error) in
                
                if error != nil {
                    print(error)
                    return
                }
               
                
                if let profileImageURL =  metadata?.downloadURL()?.absoluteString {
                    let value = ["profileImageURL": profileImageURL]
                    let uid = FIRAuth.auth()?.currentUser?.uid
                    var ref: FIRDatabaseReference!
                    ref = FIRDatabase.database().reference().child("users").child(uid!)
                    ref.updateChildValues(value)
                    
                }
            })
        }
        let segueController = VideoChooseViewController()
        present(segueController, animated: true, completion: nil)
    }
    
    

    override func viewDidLoad() {
        /*
         
        self.navigationController?.navigationBar.isHidden = true

        let background = CAGradientLayer()
        background.backgroundColor = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
        
        
        self.view.addSubview(Camerabutton)
        self.view.addSubview(profilePictureImageView)
        self.view.addSubview(MoveOnButton)
        self.view.addSubview(TitleTF)
        
        TitleTF.translatesAutoresizingMaskIntoConstraints = false
        
        TitleTF.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        TitleTF.textAlignment = NSTextAlignment.center
        TitleTF.font = UIFont.boldSystemFont(ofSize: 20)

        TitleTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        TitleTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        TitleTF.heightAnchor.constraint(equalToConstant: 30).isActive = true
        TitleTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        TitleTF.widthAnchor.constraint(equalToConstant: 30).isActive = true
        TitleTF.text = "Choose a Profile Picture"
        
        profilePictureImageView.translatesAutoresizingMaskIntoConstraints = false
        profilePictureImageView.topAnchor.constraint(equalTo: TitleTF.bottomAnchor, constant: 100).isActive = true
        profilePictureImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profilePictureImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        profilePictureImageView.image = UIImage(named: "InternULogo")
        profilePictureImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePictureImageView.contentMode = .scaleAspectFill
        
        Camerabutton.translatesAutoresizingMaskIntoConstraints = false
        Camerabutton.topAnchor.constraint(equalTo: profilePictureImageView.bottomAnchor, constant: 50).isActive = true
        Camerabutton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        Camerabutton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        Camerabutton.setTitle("Choose Picture", for: .normal)
        Camerabutton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        Camerabutton.layer.cornerRadius = 5
        Camerabutton.layer.masksToBounds = true
        Camerabutton.backgroundColor = UIColor.init(red: 100/255, green: 175/255, blue: 220/255, alpha: 1)
        Camerabutton.addTarget(self, action: #selector(handleSelectProfileImageView), for: .touchUpInside)
        
        MoveOnButton.translatesAutoresizingMaskIntoConstraints = false
        MoveOnButton.topAnchor.constraint(equalTo: Camerabutton.bottomAnchor, constant: 10).isActive = true
        
        MoveOnButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        MoveOnButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        MoveOnButton.setTitle("Continue", for: .normal)
        MoveOnButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        MoveOnButton.layer.cornerRadius = 5
        MoveOnButton.layer.masksToBounds = true
        MoveOnButton.backgroundColor = UIColor.init(red: 100/255, green: 175/255, blue: 220/255, alpha: 1)
        MoveOnButton.addTarget(self, action: #selector(uploadIntoDatabase), for: .touchUpInside)
        
*/
        
        
        
}
    
    
    
}
