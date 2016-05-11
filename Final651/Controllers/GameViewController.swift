//
//  GameViewController.swift
//  Final651
//
//  Created by WeiGuangcheng on 5/8/16.
//  Copyright (c) 2016 Guangcheng Wei. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var level = 1
    var score = 0
    var lastScore = 0
    var win = false
    let scene = GameScene(fileNamed:"GameScene")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (scene != nil) {

            scene!.controller = self
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene!.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }
    
    func result(score:Int, win:Bool) {
        self.score = score
        self.win = win
        if(self.win) {self.lastScore = score}
        performSegueWithIdentifier("GameResult", sender: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "GameResult") {
            // pass data to next view
            let svc = segue.destinationViewController as! ResultViewController;
            svc.lastScore = lastScore
            svc.score = score
            svc.win = win
        }
    }
}
