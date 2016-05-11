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
    
    func loadData(){
        let score1 = Score(avatar:nil, name: "player1", score: 123)
        let score2 = Score(avatar:nil, name: "player2", score: 223)
        scores += [score1, score2]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "UserScoreTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UserScoreTableViewCell
        
        // Configure the cell...
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
