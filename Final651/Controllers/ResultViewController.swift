//
//  ScoreListViewController.swift
//  Final651
//
//  Created by WeiGuangcheng on 5/8/16.
//  Copyright © 2016 Guangcheng Wei. All rights reserved.
//

import UIKit
import Foundation

class ResultViewController: UIViewController {
    var score = 0
    var win = false
    
    @IBOutlet weak var retryOrNextLabel: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        Score.saveScore(score)
        scoreLabel.text = "\(score)(High Score: \(Score.heighestScore()))"
        if(win) { retryOrNextLabel.setTitle("Next Level", forState: UIControlState.Normal) }
        else { retryOrNextLabel.setTitle("Retry", forState: UIControlState.Normal) }
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .Portrait
        } else {
            return .Portrait
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("RetryOrNextLevel", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "RetryOrNextLevel") {
            // pass data to next view
            let svc = segue.destinationViewController as! GameViewController;
            svc.level += 1
            svc.score = score
            svc.win = false
        }
    }
}
