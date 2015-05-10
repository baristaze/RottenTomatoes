//
//  DvdDetailViewController.swift
//  RottenTomatoes
//
//  Created by Baris Taze on 5/8/15.
//  Copyright (c) 2015 Baris Taze. All rights reserved.
//

import UIKit

class DvdDetailViewController: UIViewController {

    @IBOutlet weak var dvdImageView: UIImageView!
    
    var dvdInfo: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let title = self.dvdInfo!["title"] as! String
        self.title = title
        
        let posters = self.dvdInfo!["posters"] as! NSDictionary
        var posterUrl = posters["original"] as! String
        let index = posterUrl.rangeOfString("/movie/")?.startIndex
        posterUrl = posterUrl.substringFromIndex(index!)
        posterUrl = "http://content6.flixster.com\(posterUrl)"
        let url = NSURL(string: posterUrl)
        self.dvdImageView.setImageWithURL(url)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
