//
//  ConfirmVideoViewController.swift
//  InternTest
//
//  Created by Rahul Sheth on 9/19/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase
class ConfirmVideoViewController: UIViewController {

    var videoURL = String()
    var thumbnailImage = UIImage()
    var videoType = Int()
    var captionTF = UITextView()
    var height = UIScreen.main.bounds.height / 4
    func handleMoveToProfile() {
        let segueController = ProfilePageViewController()
        present(segueController, animated: true, completion: nil)
    }
    class playButton: UIButton  {
        var playerURL = String()
    }
    
    
    
    func MoveToVideo(sender: playButton) {
        print("Hello")
        let url = URL(string: sender.playerURL)
        
        
        
        
        let player = AVPlayer(url: (url! as URL))
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true, completion: {
            playerViewController.player?.play()
        })
        
        
        
        
    }
    
    
    func uploadToDatabase() {
                     let uid = FIRAuth.auth()?.currentUser?.uid
        
        
                    var thumbnailString = String()
                    var videoString = String()
                    var videoThumbnail = String()
                    var captionText = String()
                    switch self.videoType {
                    case 1:
                        videoString = "userVideoURL"
                        thumbnailString = "thumbnailImageURL"
                        videoThumbnail = "firstVideo"
                        captionText = "firstCaption"
                        break
                    case 2:
                        videoString = "experienceSupplementURL"
                        thumbnailString = "experienceThumbnailImage"
                        videoThumbnail = "experienceVideo"
                        captionText = "experienceCaption"
                        break
                    case 3:
                        videoString = "skillsSupplementURL"
                        thumbnailString = "skillsThumbnailImage"
                        videoThumbnail = "skillsThumbnail"
                        captionText = "skillsCaption"
                        break
                    case 4:
                        videoString = "extraSupplementURL"
                        thumbnailString = "extraThumbnailImage"
                        videoThumbnail = "extraThumbnail"
                        captionText = "extraCaption"
                        break
                    default:
                        break
        
                    }
                    let storageReference = FIRStorage.storage().reference().child(uid!).child(videoString)
                    let ai = UIActivityIndicatorView()
                    self.view.addSubview(ai)
                    ai.startAnimating()
                    ai.translatesAutoresizingMaskIntoConstraints = false
                    ai.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                    ai.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
                    ai.heightAnchor.constraint(equalToConstant: 50).isActive = true
                    ai.widthAnchor.constraint(equalToConstant: 50).isActive = true
                    ai.color = UIColor.black
        
                    let label = UILabel()
                    self.view.addSubview(label)
                    label.translatesAutoresizingMaskIntoConstraints = false
                    label.text = "Please wait..."
                    label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                    label.centerYAnchor.constraint(equalTo: ai.bottomAnchor, constant: 20).isActive = true
                    label.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 16)
                    let videoURL2 = URL(string: videoURL)
                    let uploadTask = storageReference.putFile(videoURL2!, metadata: nil, completion: { (metadata, error) in
        
                        if (error == nil) {
                            print("successful upload")
        
                        } else {
                            print("Here is your error", error)
                        }
        
                        if let storageURL = metadata?.downloadURL()?.absoluteString {
                            let value = [videoString: storageURL ]
                            print(storageURL, " This is the storageURL")
                            let ref = FIRDatabase.database().reference().child("users").child(uid!)
                            ref.updateChildValues(value)
                        }
        
        
                    })
        
                    //Fix so it updates individual about the upload of their video
                    let observe = uploadTask.observe(.progress, handler: { (snapshot) in
                        let message = "\(snapshot.progress?.fractionCompleted)! * 100.0"
                        self.view.alpha = 0.5
                        if (snapshot.progress?.fractionCompleted == 1.0) {
                            print("Congrats")
                            ai.stopAnimating()
                            label.isHidden = true
                            let alert = UIAlertController(title: "Congrats", message: "Video was successfully upload", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (error) in
        
                                self.handleMoveToProfile()
        
        
                                }))
                            self.present(alert, animated: true, completion: nil)
        
                        }
        
                    })
                    let thumbnailCGImage = thumbnailImage
        
        
                    let imageName = (videoThumbnail, uid)
                    let ref = FIRStorage.storage().reference().child("\(imageName).png")
                    if let uploadData = UIImagePNGRepresentation(thumbnailCGImage) {
                        ref.put(uploadData, metadata: nil , completion: { (metadata, error) in
                            if (error != nil) {
                                print(error)
                                return
                            }
                            if let thumbnailImageURL = metadata?.downloadURL()?.absoluteString {
                                var value = [String: NSString]()
                                if (self.captionTF.text != "") {
                                let uploadText = NSString(string: self.captionTF.text)
                                value = [thumbnailString : thumbnailImageURL as NSString, captionText: uploadText]
                                } else {
                                    value = [thumbnailString: thumbnailImageURL as NSString]
                                }
                                let ref = FIRDatabase.database().reference().child("users").child(uid!)
                                ref.updateChildValues(value)
                            }
                            
                            
                        })
                        
                        
        
                    }
    }
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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        

        
        let backButton = UIButton()
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.setImage(UIImage(named: "arrowIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(handleMoveToProfile), for: .touchUpInside)
        
        let titleLabel = UILabel()
        
        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Caption and Confirm"
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 32)
        titleLabel.textColor = UIColor.darkGray
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.bounds.height * 0.08).isActive = true
        
        var player = playButton()
        
        var imageView = UIImageView()
        self.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = thumbnailImage
        imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.8).isActive = true
        imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 75).isActive = true
        imageView.layer.borderWidth = 0.5
        imageView.addSubview(player)
        imageView.isUserInteractionEnabled = true
        
        player.playerURL = videoURL
        player.translatesAutoresizingMaskIntoConstraints = false
        player.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        player.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        player.setBackgroundImage(UIImage(named: "playIcon"), for: .normal)
        player.addTarget(self, action: #selector(MoveToVideo), for: .touchUpInside)
        player.widthAnchor.constraint(equalToConstant: 50).isActive = true
        player.heightAnchor.constraint(equalToConstant: 50).isActive = true

        
        self.view.addSubview(captionTF)
        
        captionTF.translatesAutoresizingMaskIntoConstraints = false
        captionTF.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        captionTF.heightAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        captionTF.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        captionTF.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50).isActive = true
        captionTF.layer.borderWidth = 0.5
        
        
        let confirmButton = UIButton()
        self.view.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.65).isActive = true
        confirmButton.topAnchor.constraint(equalTo: captionTF.bottomAnchor, constant: 30).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        confirmButton.setTitle("Upload", for: .normal)
        confirmButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.layer.cornerRadius = 10
        confirmButton.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
        confirmButton.addTarget(self, action: #selector(uploadToDatabase) , for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }

    func dismissKeyboard() {
        view.endEditing(true)
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
