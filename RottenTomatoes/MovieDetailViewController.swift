//
//  MovieDetailViewController.swift
//  RottenTomatoes
//
//  Created by Baris Taze on 5/8/15.
//  Copyright (c) 2015 Baris Taze. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var synopsisLabelButton: UIButton!
    
    var movie: NSDictionary?
    var requiredHeightForSynopsisLabel:CGFloat = 200.0
    var lastPanLocationY:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let title = self.movie!["title"] as! String
        self.title = title
        
        let posters = self.movie!["posters"] as! NSDictionary
        var posterUrl = posters["original"] as! String
        let index = posterUrl.rangeOfString("/movie/")?.startIndex
        posterUrl = posterUrl.substringFromIndex(index!)
        posterUrl = "http://content6.flixster.com\(posterUrl)"
        let url = NSURL(string: posterUrl)
        self.posterImageView.setImageWithURL(url)
        
        let topBorderLine = UIView(frame: CGRect(x:0, y:2, width:self.synopsisLabelButton.frame.width, height:1))
        topBorderLine.backgroundColor = UIColor(red:0.8, green:0.8, blue:0.8, alpha:0.8)
        self.synopsisLabelButton.addSubview(topBorderLine)
        
        self.synopsisLabelButton.titleLabel?.lineBreakMode = .ByWordWrapping
        self.synopsisLabelButton.titleLabel?.textAlignment = .Justified
        let synopsis = self.movie!["synopsis"] as? String
        self.synopsisLabelButton.setTitle(synopsis, forState: UIControlState.Normal)
        self.synopsisLabelButton.setTitle(synopsis, forState: UIControlState.Highlighted)
        self.synopsisLabelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        
        self.requiredHeightForSynopsisLabel = self.requiredHeightForSynopsis(synopsis!)
        var currentY:CGFloat = self.synopsisLabelButton.frame.origin.y
        var currentVisibleHeight:CGFloat = self.view.frame.height - self.synopsisLabelButton.frame.origin.y
        currentVisibleHeight = currentVisibleHeight - self.tabBarController!.tabBar.frame.size.height
        if(self.requiredHeightForSynopsisLabel < currentVisibleHeight) {
            // push down
            currentY = currentY + (currentVisibleHeight - self.requiredHeightForSynopsisLabel)
        }
        self.synopsisLabelButton.frame = CGRect(x:0, y:currentY, width:self.view.frame.width, height:self.requiredHeightForSynopsisLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requiredHeightForSynopsis(synopsis:String) -> CGFloat {
        
        return 20.0 + self.heightForLabel(
            synopsis,
            font: self.synopsisLabelButton.titleLabel!.font,
            width: (self.view.frame.width - 20.0))
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

    
    @IBAction func onDragLabel(sender: AnyObject) {
    
        let panGesture = sender as! UIPanGestureRecognizer
        let point = panGesture.translationInView(self.view)
        if(panGesture.state != UIGestureRecognizerState.Changed) {
            self.lastPanLocationY = 0.0
        }
        var deltaY = point.y - self.lastPanLocationY
        self.lastPanLocationY = point.y
        if(deltaY < 0) {
            // up
            var currentBottom = self.synopsisLabelButton.frame.origin.y + self.synopsisLabelButton.frame.height
            var absoluteBottom = self.tabBarController!.tabBar.frame.origin.y
            if(currentBottom > absoluteBottom) {
                let up = min((currentBottom - absoluteBottom), (deltaY * -1.0))
                self.synopsisLabelButton.frame = CGRect(
                    x:self.synopsisLabelButton.frame.origin.x,
                    y:(self.synopsisLabelButton.frame.origin.y-up),
                    width: self.synopsisLabelButton.frame.width,
                    height: self.synopsisLabelButton.frame.height
                )
            }
        }
        else if (deltaY > 0) {
            // down
            let minHeight = min(self.requiredHeightForSynopsisLabel, 50.0)
            var currentVisibleHeight:CGFloat = self.view.frame.height - self.synopsisLabelButton.frame.origin.y
            currentVisibleHeight = currentVisibleHeight - self.tabBarController!.tabBar.frame.size.height
            if(currentVisibleHeight > minHeight) {
                let down = min((currentVisibleHeight - minHeight), deltaY)
                self.synopsisLabelButton.frame = CGRect(
                    x:self.synopsisLabelButton.frame.origin.x,
                    y:(self.synopsisLabelButton.frame.origin.y+down),
                    width: self.synopsisLabelButton.frame.width,
                    height: self.synopsisLabelButton.frame.height
                )
            }
            
        }
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
