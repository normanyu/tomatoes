//
//  MoviesViewController.swift
//  tomatoes
//
//  Created by Norman Yu on 4/9/15.
//  Copyright (c) 2015 Norman Yu. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var movies: [NSDictionary]! = [NSDictionary]()
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        
        // add a pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        refresh()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.insertSubview(refreshControl, atIndex: 0)
        
        // Do any additional setup after loading the view.
    }

    func refresh() {
        refreshControl.beginRefreshing()
        
        var url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=nxu96vjy2huu9g3vd3kjfd2g")!
        var request = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data:NSData!, error: NSError!) -> Void in
            
            SVProgressHUD.dismiss()
            var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            
            self.movies = json["movies"] as [NSDictionary]
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        NSLog("in refresher")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as MovieCell
        
        var movie = movies[indexPath.row]
        
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        var url = movie.valueForKeyPath("posters.thumbnail") as? String
        cell.posterView.setImageWithURL(NSURL(string: url!)!)
   
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        NSLog("Navigating")
        var movieDetailViewController = segue.destinationViewController as MovieDetailViewController
        var cell = sender as UITableViewCell
        var indexPath = tableView.indexPathForCell(cell)!
        
        movieDetailViewController.movie = movies[indexPath.row]
    }
    

}
