//
//  MovieDetailViewController.swift
//  tomatoes
//
//  Created by Norman Yu on 4/9/15.
//  Copyright (c) 2015 Norman Yu. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    var movie: NSDictionary!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    @IBOutlet weak var posterView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("%@", movie)
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
        
        
        var url = movie.valueForKeyPath("posters.thumbnail") as? String
        
        var range = url!.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            url = url!.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        
        posterView.setImageWithURL(NSURL(string: url!)!)
        
        // Do any additional setup after loading the view.
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
