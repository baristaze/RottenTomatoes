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
    @IBOutlet weak var synopsisButtonLabel: UIButton!
    
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

        let topBorderLine = UIView(frame: CGRect(x:0, y:2, width:self.synopsisButtonLabel.frame.width, height:1))
        topBorderLine.backgroundColor = UIColor(red:0.8, green:0.8, blue:0.8, alpha:0.8)
        self.synopsisButtonLabel.addSubview(topBorderLine)
        
        self.synopsisButtonLabel.titleLabel?.lineBreakMode = .ByWordWrapping
        self.synopsisButtonLabel.titleLabel?.textAlignment = .Justified
        let synopsis = self.dvdInfo["synopsis"] as? String
        self.synopsisButtonLabel.setTitle(synopsis, forState: UIControlState.Normal)
        
        let expectedLabelHeight = 20.0 + self.heightForLabel(
            synopsis!,
            font: self.synopsisButtonLabel.titleLabel!.font,
            width: (self.view.frame.width - 20.0))
        
        var currentY:CGFloat = self.synopsisButtonLabel.frame.origin.y
        var currentVisibleHeight:CGFloat = self.view.frame.height - self.synopsisButtonLabel.frame.origin.y
        currentVisibleHeight = currentVisibleHeight - self.tabBarController!.tabBar.frame.size.height
        println(currentVisibleHeight)
        if(expectedLabelHeight < currentVisibleHeight) {
            // push down
            currentY = currentY + (currentVisibleHeight - expectedLabelHeight)
        }
        self.synopsisButtonLabel.frame = CGRect(x:0, y:currentY, width:self.view.frame.width, height:expectedLabelHeight)
    }

    func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
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
