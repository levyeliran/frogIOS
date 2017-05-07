//
//  GameController.swift
//  EliranFrog
//
//  Created by Eliran Levy on 21/04/2017.
//  Copyright © 2017 Eliran Levy. All rights reserved.
//

import UIKit
import AudioToolbox.AudioServices

class RandomGameController: UIViewController {
    
    var level = GAME_LEVEL.HARD
    
    @IBOutlet weak var missedLabel: UILabel!
    @IBOutlet weak var hitsLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var gameBoardView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    
    var topX:CGFloat = 0.0
    var topY:CGFloat = 0.0
    var bottomX:Int = 0
    var bottomY:Int = 0
    var displayedFrogs = [FrogImageView]()
    var frogTimeout = 4
    var counter = 20
    var frogMngr = FrogManager()
    var timer: NSTimer?
    var hits = 0
    var missed = 0
    var countDownFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.displayedFrogs = [FrogImageView]()
        self.gameBoardView.backgroundColor = UIColor.clearColor()
        self.hitsLabel.text = "0"
        self.missedLabel.text = "0"
        self.countDownLabel.text = ""
        self.topX = self.gameBoardView.frame.origin.x
        self.topY = self.gameBoardView.frame.origin.y
        self.bottomX = Int(self.gameBoardView.frame.width - self.topX - 5)
        self.bottomY = Int(self.gameBoardView.frame.height - 5)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        let targetAlert:UIAlertController = self.frogMngr.getTargetAlert(30, miss: 3, sec: Int(self.counter) ,okButtonHandler: { (action) -> Void in
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "onTimerUpdate", userInfo: nil, repeats: true)
        })
        self.presentViewController(targetAlert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextView = segue.destinationViewController as! ScoreController
        nextView.hits = self.hits
        nextView.missed = self.missed
        nextView.level = self.level
        
    }
    
    func frogImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let imgView = tapGestureRecognizer.view as! UIImageView
        //remove from the displayed positions
        let index = self.displayedFrogs.indexOf{ $0.imgView == imgView }
        if index >= 0
        {
            let frog = self.displayedFrogs.removeAtIndex(index!)
            
            if frog.isGoodFrog {
                self.frogMngr.playFrogSound()
                self.hits++
                self.hitsLabel.text = "\(self.hits)"
            }
            else {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.missed++
                self.missedLabel.text = "\(self.missed)"
            }
            
            frog.imgView.removeFromSuperview()
        }
        
        //calculate score
        self.scoreStatus()
    }
    
    
    func onTimerUpdate(){
        if self.counter <= 0 {
            self.stopTimer()
            //remove all displayed frogs
            self.removeFrogs()
            self.counter = 0
            self.frogMngr.stopCountDownMusic()
            
            //display score
            self.displayScore()
        }
        else {
            if self.counter <= 11 {
                if !self.countDownFlag{
                    self.countDownFlag = true
                    self.frogMngr.bloat(self.countDownLabel)
                }
            }
            
            if self.frogTimeout <= 0 {
                self.frogTimeout = Int(arc4random_uniform(4) + 1)
                //remove all displayed frogs
                self.removeFrogs()
            }
            
            counter--
            self.frogTimeout--
            
            let c = Int(arc4random_uniform(3))
            //add random frogs
            for _ in 0...c {
                let frog = frogMngr.getRandomFrog(self.bottomX, yBottom: self.bottomY)
                self.displayedFrogs.append(frog)
                
                let imgView = frog.imgView
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "frogImageTapped:")
                imgView.userInteractionEnabled = true
                imgView.addGestureRecognizer(tapGestureRecognizer)
                
                self.gameBoardView.addSubview(imgView)
            }
        }
        self.countDownLabel.text = "\(Int(self.counter))"
        
    }
    
    func removeFrogs(){
        for item in self.displayedFrogs {
            item.imgView.removeFromSuperview()
        }
        self.displayedFrogs.removeAll()
        
        //calculate score
        self.scoreStatus()
    }
    
    
    func scoreStatus(){
        var isWon = false
        var isLost = false
        
        if self.hits >= 30 {
            isWon = true
        }
        else if self.missed >= 3 {
            isLost = true
        }
        
        if (isWon || isLost){
            self.displayScore()
        }
    }
    
    
    func displayScore(){
        self.stopTimer()
        performSegueWithIdentifier("viewScoreSeg", sender: self)
    }
    
    func stopTimer(){
        self.timer?.invalidate()
    }
    
    
    @IBAction func onBackButtonClick(sender: AnyObject) {
        self.stopTimer()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
}
