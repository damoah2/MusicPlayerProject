//
//  RootTableViewController.swift
//  MusicPlayer
//
//  Created by Dennis Amoah on 4/15/22.
//

import Foundation
import UIKit

class RootTableViewController: UITableViewController {
    
    // assign MusicArray to class created in MusicPlayer.swift
    var MusicArray = [MusicPlayer]()
    
    // create a function to pull data from JSON on Github
    func populateMusicArrayFromJSON() {
        // need to have a string
        let endPointString = "https://raw.githubusercontent.com/damoah2/Project2/main/SongLists.json"
        
        // convert to URL
        let endPoint = URL(string: endPointString)
        
        // Execute the EndPoints
        let responseBytes = try? Data(contentsOf: endPoint!)
        print("response bytes --- \(String(describing: responseBytes))")
        
        // verify
        if (responseBytes != nil) {
            // get the JSON Objects
            let dictionary: NSDictionary = (try! JSONSerialization.jsonObject(with: responseBytes!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
            
            print("Dictionary --: \(dictionary) ---- \n") // for debugging purposes
        
            // Seperate the JSON objects eleminate (Status = ok) only keep SongLists
            let mpDictionary = dictionary["SongLists"]! as! [[String:AnyObject]] // targers "SongLists" in JSON
        
            // Reterive JSON Music Player Dictionary object
            for index in 0...mpDictionary.count - 1 {
                // Dictionary to Single Object (Music Player)
                let singleMP = mpDictionary[index]
                
                // create the Music Player Object
                let mp = MusicPlayer()
                
                // reterive each object from the dictionary
                mp.MusicName = singleMP["MusicName"] as! String
                mp.MusicArtist = singleMP["MusicArtist"] as! String
                mp.MusicImage = singleMP["MusicImage"] as! String
                mp.MusicDetail = singleMP["MusicDetail"] as! String
                mp.MusicSite = singleMP["MusicSite"] as! String
            
                // populate the MusicArray array
                MusicArray.append(mp)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // the source controller has this function.
        // this function passes selected object from the tableview / array to the destination segue controller
        let selectedRowObject = MusicArray[tableView.indexPathForSelectedRow!.row]
        
        let destinationController = segue.destination as! ViewController
        destinationController.globalSelected = selectedRowObject
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // call Music detial from function
        //populateMusicArray()
        populateMusicArrayFromJSON()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MusicArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellName")
        
        let selectedTrail = MusicArray[indexPath.row]
        cell!.textLabel!.text = selectedTrail.MusicName
        cell!.detailTextLabel!.text = selectedTrail.MusicArtist
        
        return cell!
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
}
