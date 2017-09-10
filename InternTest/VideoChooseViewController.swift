//
//  VideoChooseViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 1/4/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import FirebaseStorage
import MobileCoreServices
import Firebase
import Photos


//This is where you choose the very first video. 


class VideoChooseViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate, UITextViewDelegate {
    
    //INITIALIZATION OF VARIABLES 
    
    let imagePickerController = UIImagePickerController()
    var captionTF = UITextView()
    let titleLabel = UILabel()
    var videoType: Int?
    
    
    //---------------------------------------------------------------------
    
    //HELPER FUNCTIONS AND VIEWDIDLOAD 
    
    //Choose a video
    func handleChoosingVideo() {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.movie", kUTTypeImage as String, kUTTypeMovie as String]
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func handleMoveOn() {
        let segueController = ProfilePageViewController()
        
        self.present(segueController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
            
            dismiss(animated: true, completion: nil)
            
            
            let player = AVPlayer(url: (videoURL as URL))
            
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            present(playerViewController, animated: true) {
                playerViewController.player!.play()
                
                
            }
            
             let uid = FIRAuth.auth()?.currentUser?.uid
            
            
            var thumbnailString = String()
            var videoString = String()
            var videoThumbnail = String()
            switch self.videoType! {
            case 1:
                videoString = "userVideoURL"
                thumbnailString = "thumbnailImageURL"
                videoThumbnail = "firstVideo"
                break
            case 2:
                videoString = "experienceSupplementURL"
                thumbnailString = "experienceThumbnailImage"
                videoThumbnail = "experienceVideo"
                break
            case 3:
                videoString = "skillsSupplementURL"
                thumbnailString = "skillsThumbnailImage"
                videoThumbnail = "skillsThumbnail"
                break
            case 4:
                videoString = "extraSupplementURL"
                thumbnailString = "extraThumbnailImage"
                videoThumbnail = "extraThumbnail"
                break
            default:
                break

            }
            let storageReference = FIRStorage.storage().reference().child(uid!).child(videoString)

            let uploadTask = storageReference.putFile(videoURL, metadata: nil, completion: { (metadata, error) in

                if (error == nil) {
                    print("successful upload")
                    
                } else {
                    print("Here is your error", error)
                }
                
                if let storageURL = metadata?.downloadURL()?.absoluteString {
                    print(videoString)
                    let value = [videoString: storageURL ]
                    print(storageURL, " This is the storageURL")
                    let ref = FIRDatabase.database().reference().child("users").child(uid!)
                    ref.updateChildValues(value)
                }
                
                
            })
            
            //Fix so it updates individual about the upload of their video
            let observe = uploadTask.observe(.progress, handler: { (snapshot) in
                
                let message = "\(snapshot.progress?.fractionCompleted)! * 100.0"
                print(message)
                
                
            })
            let thumbnailCGImage = returnImage(fileURL: videoURL as NSURL)
            
            
            let imageName = (videoThumbnail, uid)
            let ref = FIRStorage.storage().reference().child("\(imageName).png")
            if let uploadData = UIImagePNGRepresentation(thumbnailCGImage!) {
                ref.put(uploadData, metadata: nil , completion: { (metadata, error) in
                    if (error != nil) {
                        print(error)
                        return
                    }
                    if let thumbnailImageURL = metadata?.downloadURL()?.absoluteString {
                        let value = [thumbnailString : thumbnailImageURL]
                        let ref = FIRDatabase.database().reference().child("users").child(uid!)
                        ref.updateChildValues(value)
                    }
                    
                    
                })
                
                
                
            }
            
        }
        
        

            
        
       
        
        
        
        
        
    }
    
    //return a thumbnail image for upload 
    
    
    func returnImage(fileURL: NSURL) -> UIImage? {
        let asset = AVURLAsset(url: fileURL as URL, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        do {
            let cgImage =  try imgGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch let error {
            print(error)
        }
        return nil
    }
    
    func handleMoveToProfile() {
        let segueController = ProfilePageViewController()
        present(segueController, animated: true, completion: nil)
    }
    //View Did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
      //  self.view.addSubview(captionTF)

        let backButton = UIButton()
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.setImage(UIImage(named: "arrowIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(handleMoveToProfile), for: .touchUpInside)
        
        let continueButton = UIButton()
        self.view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.65).isActive = true
        continueButton.topAnchor.constraint(equalTo: view.topAnchor, constant: self.view.bounds.height * 0.37).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        continueButton.setTitle("Choose", for: .normal)
        continueButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.layer.cornerRadius = 10
        continueButton.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
        continueButton.addTarget(self, action: #selector(handleChoosingVideo), for: .touchUpInside)
        
        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Choose a Video"
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 32)
        titleLabel.textColor = UIColor.darkGray
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.bounds.height * 0.08).isActive = true
        
        
        let descriptionLabel = UILabel()
        self.view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        switch videoType! {
        case 1:
            descriptionLabel.text = "Choose a main video. This will be your first introduction to recruiters so make sure to reel them in and give a short description of yourself"
            break
        case 2:
            descriptionLabel.text = "Choose a supplemental video. This can showcase any sort of work experience that you may have. Remember, that this is optional but highly recommended!"
            break
        case 3:
            descriptionLabel.text = "Choose a supplemental video. This can showcase any other skills you may have that would be useful in the workplace. Remember, this is optional but highly recommended!"
            break
        case 4:
            descriptionLabel.text = "Choose a supplemental video. This can showcase anything else you can bring to the table that you didn't mention in your other videos. Remember, this is optional but highly recommended!"
            break
        default:
            descriptionLabel.text = "Choose a video"
        }
        descriptionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        descriptionLabel.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: ((self.view.bounds.height * 0.37) - (self.view.bounds.height * 0.08 + 30))).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: continueButton.widthAnchor).isActive = true 
        descriptionLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 16)
        // Do any additional setup after loading the view.
    }
    
    //Setting a caption and setting the max amt of characters for the caption 
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = captionTF.text else {return true}
        
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 300
    }

   
    

}
