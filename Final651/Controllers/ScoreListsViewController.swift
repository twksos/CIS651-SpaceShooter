//
//  ScoreListViewController.swift
//  Final651
//
//  Created by WeiGuangcheng on 5/8/16.
//  Copyright © 2016 Guangcheng Wei. All rights reserved.
//

import UIKit
import Foundation

class ScoreListViewController: UITableViewController {
    
    var scores = [Score]()
    
    // load nearby user scores
    func loadData(){
        let location = Location.instance
        let requestURL: NSURL = NSURL(string: "http://twksos.com/score.php?lat=\(location.latitude)&lng=\(location.longtitude)")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            if((response == nil)) {return}
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                do{
                    // decode json
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    
                    // find scores
                    if let nearScores = json["scores"] as? [[String: AnyObject]] {
                        // empty old scores
                        self.scores = [Score]()
                        // for all records
                        for record in nearScores {
                            // parse name
                            if let userName = record["name"] as? String {
                                // parse score
                                if let userScore = record["score"] as? Int {
                                    print("%@ (scored: %@)",userName, userScore)
                                    // put into scores
                                    self.scores += [Score(avatar:nil, name: userName, score: userScore)]
                                }
                            }
                        }
                    }
                    
                    // reload tabel view on UI thread
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                }catch {
                    print("Error with Json: \(error)")
                }
            }
        }
        
        // start request
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "UserScoreTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UserScoreTableViewCell
        
        // configure the cell
        let score = scores[indexPath.row]
        cell.name.text = score.name
        cell.score.text = String(score.score)
        
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
