//
//  DVDsViewController.swift
//  RottenTomatoes
//
//  Created by Baris Taze on 5/8/15.
//  Copyright (c) 2015 Baris Taze. All rights reserved.
//

import UIKit

class DVDsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var dvdsCollectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    
    var infiniteLoadingStarted:Bool=false
    var refreshControl:UIRefreshControl!
    
    var dvdsData: NSMutableArray!
    var dvdsDataFiltered: NSMutableArray!
    
    typealias onDVDsRetrieved = (NSArray) -> (Void)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dvdsCollectionView.dataSource = self
        self.dvdsCollectionView.delegate = self
        
         self.navigationItem.titleView = self.searchBar;
        self.searchBar.delegate = self
        
        // create refreshing control
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.dvdsCollectionView.insertSubview(self.refreshControl, atIndex: 0)
        
        self.dvdsData = NSMutableArray()
        self.dvdsDataFiltered = NSMutableArray()
        self.loadMoreDVDsWithOptions(false, removeFooter: false);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dvdsDataFiltered?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.dvdsCollectionView.dequeueReusableCellWithReuseIdentifier("com.baris.rotten.dvds.cell", forIndexPath: indexPath) as! DvdCollectionCell
        
        
        let movie = self.dvdsDataFiltered[indexPath.row] as! NSDictionary;
        let posters = movie["posters"] as! NSDictionary
        let posterThumbnail = posters["thumbnail"] as! String
        let posterThumbnailUrl = NSURL(string: posterThumbnail)
        cell.dvdImageView.setImageWithURL(posterThumbnailUrl)
        
        var count = self.dvdsDataFiltered?.count ?? 0;
        if(!self.isFiltered() && !self.infiniteLoadingStarted && indexPath.row == (self.dvdsDataFiltered.count-1)){
            self.loadMoreDVDsWithOptions(false, removeFooter: true);
        }
        
        return cell
    }
    
    func loadMoreDVDsWithOptions(endRefreshing:Bool, removeFooter:Bool){
        
        self.queryDVDsWithCallback({(data:NSArray)->(Void) in
            
            if(endRefreshing){
                var all = NSMutableArray(array: data as [AnyObject])
                all.addObjectsFromArray(self.dvdsData as [AnyObject])
                self.dvdsData = all
            }
            else {
                self.dvdsData.addObjectsFromArray(data as [AnyObject])
            }
            
            self.reloadTableData()
            
            if(endRefreshing){
                self.refreshControl.endRefreshing()
            }
            
            if(removeFooter){
                self.infiniteLoadingStarted = false;
                // self.footer.removeFromSuperview()
            }
        })
    }
    
    func onRefresh() {
        
        if(self.isFiltered()){
            self.refreshControl.endRefreshing()
            return
        }
        
        self.loadMoreDVDsWithOptions(true, removeFooter: false);
    }
    
    func queryDVDsWithCallback(callback:onDVDsRetrieved){
        
        // show spinner
        SVProgressHUD.show()
        
        let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json")!
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            // test-only: let the spinner be explicit
            NSThread.sleepForTimeInterval(1.0)
            
            if (error == nil) {
                var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
                var data = responseDictionary["movies"] as! NSArray
                callback(data)
            }
            else {
            }
            
            // dismiss spinner
            SVProgressHUD.dismiss()
        }
    }
    
    func reloadTableData(){
        
        self.dvdsDataFiltered.removeAllObjects()
        
        var filter = getFilter()
        let length = count(filter)
        if(length > 0){
            for movie in self.dvdsData {
                let title = movie["title"] as? String
                let synopsis = movie["synopsis"] as? String
                if((title != nil && title!.rangeOfString(filter) != nil) || (synopsis != nil && synopsis!.rangeOfString(filter) != nil)) {
                    self.dvdsDataFiltered.addObject(movie as AnyObject)
                }
            }
        }
        else{
            self.dvdsDataFiltered.addObjectsFromArray(self.dvdsData as [AnyObject])
        }
        
        self.dvdsCollectionView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        
        self.reloadTableData();
        
        if(!self.isFiltered()) {
            NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("endSearching"), userInfo: nil, repeats: false)
        }
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.endSearching()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.endSearching()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.endSearching()
    }
    
    func endSearching() {
        self.searchBar.endEditing(true)
        self.searchBar.resignFirstResponder()
    }

    
    func getFilter() -> String {
        var filter = self.searchBar.text;
        return filter.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    func isFiltered() -> Bool {
        return count(self.getFilter()) >  0
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var indexPath = self.dvdsCollectionView.indexPathForCell(sender as! UICollectionViewCell)
        let dvdInfo = self.dvdsDataFiltered[indexPath!.row] as! NSDictionary;
        
        var vc = segue.destinationViewController as! DvdDetailViewController
        vc.dvdInfo = dvdInfo
    }
}
