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
    
    var tableFooterView:UIView!
    var infiniteLoadingStarted:Bool=false
    var refreshControl:UIRefreshControl!
    var moviesData: NSMutableArray!
    
    typealias onMoviesRetrieved = (NSArray) -> (Void)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.movieTableView.insertSubview(self.refreshControl, atIndex: 0)
        
        self.movieTableView.dataSource = self
        
        self.movieGridView.removeFromSuperview()
        self.view.addSubview(self.movieTableView)
        
        //self.movieTableView.removeFromSuperview()
        //self.view.addSubview(self.movieGridView)
        
        self.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 55))
        var loadingView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        loadingView.startAnimating()
        loadingView.center = tableFooterView.center
        
        self.moviesData = NSMutableArray()
        self.loadMoreMoviesWithOptions(false, removeFooter: false);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMoreMoviesWithOptions(endRefreshing:Bool, removeFooter:Bool){
        
        self.queryMoviesWithCallback({(data:NSArray)->(Void) in
            
            if(endRefreshing){
                var all = NSMutableArray(array: data as [AnyObject])
                all.addObjectsFromArray(self.moviesData as [AnyObject])
                self.moviesData = all
            }
            else {
                self.moviesData.addObjectsFromArray(data as [AnyObject])
            }
            
            self.movieTableView.reloadData()
            
            if(endRefreshing){
                self.refreshControl.endRefreshing()
            }
            
            if(removeFooter){
                self.infiniteLoadingStarted = false;
                self.tableFooterView.removeFromSuperview()
            }
        })
    }
    
    func onRefresh() {
        self.loadMoreMoviesWithOptions(true, removeFooter: false);
    }
    
    func queryMoviesWithCallback(callback:onMoviesRetrieved){
        
        let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")!
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if (error == nil) {
                var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
                var data = responseDictionary["movies"] as! NSArray
                callback(data)
            }
            else {
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moviesData?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.movieTableView.dequeueReusableCellWithIdentifier("com.baris.rotten.movies.cell", forIndexPath: indexPath) as! MoviesTableCell
        
        let movie = self.moviesData[indexPath.row] as! NSDictionary;
        let posters = movie["posters"] as! NSDictionary
        let posterThumbnail = posters["thumbnail"] as! String
        let posterThumbnailUrl = NSURL(string: posterThumbnail)
        cell.movieImageView.setImageWithURL(posterThumbnailUrl)
        cell.movieSnopsisLabel.text = movie["synopsis"] as? String
        cell.movieTitleLabel.text = movie["title"] as? String
        
        var count = self.moviesData?.count ?? 0;
        if(!self.infiniteLoadingStarted && indexPath.row == self.moviesData.count){
            self.movieTableView.tableFooterView = self.tableFooterView;
            self.loadMoreMoviesWithOptions(false, removeFooter: true);
        }
        
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
