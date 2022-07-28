//
//  DetailViewController.swift
//  MusicPlayer
//
//  Created by Dennis Amoah on 5/4/22.
//

import Foundation
import UIKit
import WebKit

class DetailViewController : UIViewController {
    
    @IBOutlet weak var IblMusicName: UILabel!
    
    
    @IBOutlet weak var wvMusicSite: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setContent()
    }
    
    func setContent() {
        IblMusicName.text = SongObject.MusicName
        
        //display website
        let siteURL = URL(string: SongObject.MusicSite)
        let request = URLRequest(url: siteURL!)
        wvMusicSite.load(request)
        
    }
    
    var SongObject = MusicPlayer()
}
