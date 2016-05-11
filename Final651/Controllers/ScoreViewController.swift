//
//  ScoreViewController.swift
//  Final651
//
//  Created by WeiGuangcheng on 5/8/16.
//  Copyright © 2016 Guangcheng Wei. All rights reserved.
//

import UIKit
import Foundation

class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ScoreTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ScoreTableViewCell
        
        // configure the cell
        let score = scores[indexPath.row]
        cell.scoreLabel.text = String(score.score)
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
