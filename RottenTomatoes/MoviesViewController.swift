//
//  MoviesViewController.swift
//  RottenTomatoes
//
//  Created by Baris Taze on 5/8/15.
//  Copyright (c) 2015 Baris Taze. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var movieGridView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.movieTableView.dataSource = self
        
        self.movieGridView.removeFromSuperview()
        self.view.addSubview(self.movieTableView)
        
        //self.movieTableView.removeFromSuperview()
        //self.view.addSubview(self.movieGridView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.movieTableView.dequeueReusableCellWithIdentifier("com.baris.rotten.movies.cell", forIndexPath: indexPath) as! MoviesTableCell
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
