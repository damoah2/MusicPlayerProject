//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Dennis Amoah on 3/27/22.
//
// Disclaimer
/*
Disclaimer:

This App is developed as an educational project. If any copyrighted
materials are included in accordance to the multimedia fair use
guidelines, a notice should be added and states that “certain materials
are included under the fair use exemption of the U.S. Copyright Lawand
have been prepared according to the multimedia fair use guidelines and
are restricted from further use”
*/

import UIKit
import AVKit
import AVFoundation


class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var imgSong: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblArtist: UILabel!
     
    
    @IBOutlet weak var tvDescription: UITextView!
    
    @IBOutlet weak var imgUser: UIImageView!
    
    
    //global variable  - allocate memory
    var globalSelected = MusicPlayer()
    
    // assign MusicArray to class created in MusicPlayer.swift
    var MusicArray = [MusicPlayer]()

    //sound
    var mySound:AVAudioPlayer!
    var soundEffect:AVAudioPlayer!
    
    // Segues for Detail View Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailSegue" {
            let destController = segue.destination as! DetailViewController
            
            destController.SongObject = globalSelected
            
        }// end of if statement
        
    }// end of func
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //populateMusicArray()
        
        // loads the content when the app starts
        SetLabels()
        
        // pulls music from local folder
        let loadingScreenSound = URL(fileURLWithPath: Bundle.main.path(forResource: "ui_loading", ofType: "wav")!)
        
        
        
        mySound = try? AVAudioPlayer(contentsOf: loadingScreenSound)
        
        // plays loading effect
        mySound.play()
        
        // tap effect
        let tapEffect = URL(fileURLWithPath: Bundle.main.path(forResource: "ui_tap-variant-01", ofType: "wav")!)
        soundEffect = try? AVAudioPlayer(contentsOf: tapEffect)
        
    }
    
    // Motion event
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        imgSong.alpha = 0
        lblTitle.alpha = 0
        lblArtist.alpha = 0
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        UIView.animate(withDuration: 3, animations: {
            self.imgSong.alpha = 1
            self.lblTitle.alpha = 1
            self.lblArtist.alpha = 1
        })
        
        SetLabels()
    }// end of func
    
    //choose other music
    
    fileprivate func SetLabels() {
        //let randomSong = MusicArray.randomElement()
        
        // making randomSong global
        //globalSelected = randomSong!
        
        let randomSong = globalSelected
        
        //setting Image
        //imgSong.image = UIImage(named: randomSong.MusicImage)
        imgSong.image =  convertToImage(urlString: randomSong.MusicImage)
        
        
        //imgSong.contentMode = UIView.ContentMode.scaleAspectFit
        imgSong.layer.cornerRadius = 10
        imgSong.clipsToBounds = true
        imgSong.layer.borderWidth = 1
        imgSong.layer.borderColor = UIColor.lightGray.cgColor
        
        imgSong.layer.shadowColor = UIColor.black.cgColor
        imgSong.layer.shadowOffset = CGSize(width: 10, height: 10)
        imgSong.layer.shadowRadius = 10.0
        imgSong.layer.shadowOpacity = 0.5
        
        
        
        // MusicName
        // the ?  makes it optional
        lblTitle.text = randomSong.MusicName
        
        //MusicArtist
        lblArtist.text = randomSong.MusicArtist
        
        //MusicDetail
        tvDescription.text = randomSong.MusicDetail
        tvDescription.layer.cornerRadius = 15
        tvDescription.clipsToBounds = true
        tvDescription.layer.borderWidth = 1
        tvDescription.layer.borderColor = UIColor.lightGray.cgColor
    }//  end of function
    
    // change image button
    @IBAction func changePicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraController = UIImagePickerController()
            cameraController.sourceType = .camera
            cameraController.cameraCaptureMode = .photo
            cameraController.delegate = self
            cameraController.allowsEditing = true
            self.present(cameraController, animated: true, completion: nil)
        }
    }
    
    //set new user image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            imgUser.contentMode = .scaleAspectFit
            imgUser.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //func for url to image
    func convertToImage (urlString: String) -> UIImage {
        // Reach out to the URL to download bytes of data
        // converting string to URL type
        let imgURL = URL(string: urlString)!
        // 2. call the end point and receive the Bytes
        let imgData = try? Data(contentsOf: imgURL)
        print(imgData ?? "Error. Image does not exist ar URL \(imgURL)")
        
        // convert bytes of the data to image type
        let img = UIImage(data: imgData!)
        // return the UIImage
        return img!
    }
     
    
} // end of class

