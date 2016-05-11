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
    var lastScore = 0
    var win = false
    
    let winImage = UIImage(named: "win.png")!
    let loseImage = UIImage(named: "TryAgain.jpg")!
    
    @IBOutlet weak var retryOrNextLabel: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // when appear
    override func viewWillAppear(animated: Bool) {
        // save the score
        Score.saveScore(score)
        // set high score
        scoreLabel.text = "\(score)(High Score: \(Score.heighestScore()))"
        // set label to next level when win
        if(win) {
            retryOrNextLabel.setTitle("Next Level", forState: UIControlState.Normal)
            imageView.image = winImage
        }
        // else set to retry
        else {
            retryOrNextLabel.setTitle("Retry", forState: UIControlState.Normal)
            imageView.image = loseImage
        }
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
    
    // forgot change the name, go back to game view controller for next level or retry
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("RetryOrNextLevel", sender: self)
    }
    
    // setup data before go back to game view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "RetryOrNextLevel") {
            // pass data to next view
            let svc = segue.destinationViewController as! GameViewController;
            svc.lastScore = lastScore
            if(!win) {svc.score = lastScore}
            else {svc.level += 1}
            svc.win = false
        }
    }
}
