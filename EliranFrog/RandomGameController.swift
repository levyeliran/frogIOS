//
//  GameController.swift
//  EliranFrog
//
//  Created by Eliran Levy on 21/04/2017.
//  Copyright © 2017 Eliran Levy. All rights reserved.
//

import UIKit
import AudioToolbox.AudioServices
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class RandomGameController: UIViewController {
    
    var level = GAME_LEVEL.hard
    
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
    var timer: Timer?
    var hits = 0
    var missed = 0
    var countDownFlag = false
    var shouldDisappear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.displayedFrogs = [FrogImageView]()
        self.gameBoardView.backgroundColor = UIColor.clear
        self.hitsLabel.text = "0"
        self.missedLabel.text = "0"
        self.countDownLabel.text = ""
        self.topX = self.gameBoardView.frame.origin.x
        self.topY = self.gameBoardView.frame.origin.y
        self.bottomX = Int(self.gameBoardView.frame.width - self.topX - 5)
        self.bottomY = Int(self.gameBoardView.frame.height - 5)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !shouldDisappear {
            let targetAlert:UIAlertController = self.frogMngr.getTargetAlert(30, miss: 3, sec: Int(self.counter) ,okButtonHandler: { (action) -> Void in
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RandomGameController.onTimerUpdate),     userInfo: nil, repeats: true)
            })
            self.present(targetAlert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shouldDisappear {
            self.dismiss(animated: false, completion: {})
        }
    }
    
    
    func frogImageTapped(_ tapGestureRecognizer: UITapGestureRecognizer)
    {
        let imgView = tapGestureRecognizer.view as! UIImageView
        //remove from the displayed positions
        let index = self.displayedFrogs.index{ $0.imgView == imgView }
        if index >= 0
        {
            let frog = self.displayedFrogs.remove(at: index!)
            
            if frog.isGoodFrog {
                self.frogMngr.playFrogSound()
                self.hits += 1
                self.hitsLabel.text = "\(self.hits)"
            }
            else {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.missed += 1
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
            
            counter -= 1
            self.frogTimeout -= 1
            
            let c = Int(arc4random_uniform(3))
            //add random frogs
            for _ in 0...c {
                let frog = frogMngr.getRandomFrog(self.bottomX, yBottom: self.bottomY)
                self.displayedFrogs.append(frog)
                
                let imgView = frog.imgView
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RandomGameController.frogImageTapped(_:)))
                imgView.isUserInteractionEnabled = true
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
        self.shouldDisappear = true
        //display confirm
        print("finish")
    }
    
    func stopTimer(){
        self.timer?.invalidate()
    }
    
    
    @IBAction func onBackButtonClick(_ sender: AnyObject) {
        self.stopTimer()
        self.dismiss(animated: true, completion: nil)
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
}
