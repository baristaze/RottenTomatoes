//
//  DVDsViewController.swift
//  RottenTomatoes
//
//  Created by Baris Taze on 5/8/15.
//  Copyright (c) 2015 Baris Taze. All rights reserved.
//

import UIKit

class DVDsViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var dvdsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dvdsCollectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.dvdsCollectionView.dequeueReusableCellWithReuseIdentifier("com.baris.rotten.dvds.cell", forIndexPath: indexPath) as! DvdCollectionCell
        
        let url = NSURL(string:"http://lorempixel.com/400/400/")
        cell.dvdImageView.setImageWithURL(url)
        
        return cell
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
