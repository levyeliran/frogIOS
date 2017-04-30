//
//  GameController.swift
//  EliranFrog
//
//  Created by Eliran Levy on 21/04/2017.
//  Copyright © 2017 Eliran Levy. All rights reserved.
//

import UIKit

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
    var counter = 60
    var frogMngr = FrogManager()
    var timer: NSTimer?
    var hits = 0
    var missed = 0
    var countDownFlag = false
    var tapGestureRecognizer = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.displayedFrogs = [FrogImageView]()
        self.gameBoardView.backgroundColor = UIColor.clearColor()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "onTimerUpdate", userInfo: nil, repeats: true)
        self.hitsLabel.text = "0"
        self.missedLabel.text = "0"
        self.countDownLabel.text = ""
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "frogsBG")!)
        self.topX = self.gameBoardView.frame.origin.x
        self.topY = self.gameBoardView.frame.origin.y
        self.bottomX = Int(self.gameBoardView.frame.width - self.topX - 5)
        self.bottomY = Int(self.gameBoardView.frame.height - 5)
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "frogImageTapped")
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
                self.hits++
                self.hitsLabel.text = "\(self.hits)"
            }
            else {
                self.missed++
                self.missedLabel.text = "\(self.missed)"
            }
            
            frog.imgView.removeFromSuperview()
        }
    }
    
    
    func onTimerUpdate(){
        if self.counter <= 0 {
            self.stopTimer()
            //remove all displayed frogs
            self.removeFrogs()
            self.counter = 0
            self.countDownLabel.text = "\(Int(self.counter))"
            
            //display score
            self.displayScore()
        }
        else {
            if self.counter <= 10 {
                if !self.countDownFlag{
                    self.countDownFlag = true
                    self.frogMngr.bloat(self.countDownLabel)
                }
                self.countDownLabel.text = "\(Int(self.counter))"
            }
            
            if self.frogTimeout <= 0 {
                self.frogTimeout = 4
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
                imgView.userInteractionEnabled = true
                imgView.addGestureRecognizer(tapGestureRecognizer)
                
                self.gameBoardView.addSubview(imgView)
            }
        }
    }
    
    func removeFrogs(){
        for item in self.displayedFrogs {
            //loose point for each bad frog
            if !item.isGoodFrog{
                missed--
            }
            item.imgView.removeFromSuperview()
        }
        self.displayedFrogs.removeAll()
    }
    
    
    func displayScore(){
        
    }
    
    func stopTimer(){
        self.timer?.invalidate()
    }
    
    
    @IBAction func onBackButtonClick(sender: AnyObject) {
        self.stopTimer()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
