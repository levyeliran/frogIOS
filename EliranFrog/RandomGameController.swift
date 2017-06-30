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
    @IBOutlet weak var firstHelpImage: UIImageView!
    @IBOutlet weak var secondHelpImage: UIImageView!
    @IBOutlet weak var thirdHelpImage: UIImageView!
    
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
    var isWon = false
    var isLost = false
    var pauseFrogsCounter = 0
    var isDeviceShaked = false
    var deviceShakedHelps = 3
    var deviceShakedCounter = 0
    var countDownMusicPaused = false
    var isNewRecord = false

    
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
            let targetAlert:UIAlertController = self.frogMngr.getTargetAlert( miss: 3, sec: Int(self.counter) ,okButtonHandler: { (action) -> Void in
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RandomGameController.onTimerUpdate),     userInfo: nil, repeats: true)
            })
            self.present(targetAlert, animated: true, completion: nil)
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
                self.hits += 10
                self.hitsLabel.text = "\(self.hits)"
            }
            else {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.pauseFrogsCounter = 3
                //remove all good frogs
                for (_, frg) in displayedFrogs.enumerated() {
                    if (frg.isGoodFrog) {
                        frg.imgView.zoomOut()
                        frg.imgView.removeFromSuperview()
                    }
                }
                self.missed += 1
                self.missedLabel.text = "\(self.missed)"
            }
            frog.imgView.zoomOut()
            frog.imgView.removeFromSuperview()
        }
    }
    
    
    func onTimerUpdate(){
        if self.counter <= 0 {
            self.countDownLabel.text = " "
            self.stopTimer()
            //remove all displayed frogs
            self.removeFrogs()
            self.counter = 0
            self.frogMngr.stopCountDownMusic()
            countDownLabel.removeFromSuperview()
            
            //calculate score
            self.scoreStatus()
            //display score
            self.displayScore()
        }
        else {
            if self.counter <= 11 {
                
                if self.pauseFrogsCounter > 0 {
                    self.countDownLabel.textColor = UIColor.red
                    self.pauseFrogsCounter-=1
                    counter-=1
                    self.countDownLabel.text = "\(Int(self.counter))"
                    return
                }
                
                if !self.countDownFlag{
                    self.countDownFlag = true
                    self.frogMngr.bloat(self.countDownLabel)
                }
            }
            
            if self.pauseFrogsCounter > 0 {
                self.countDownLabel.textColor = UIColor.red
                self.pauseFrogsCounter-=1
                counter-=1
                self.countDownLabel.text = "\(Int(self.counter))"
                return
            }
            
            if self.isDeviceShaked && self.deviceShakedCounter > 0 {
                self.generateFrogs()
                self.deviceShakedCounter-=1
                self.isDeviceShaked = self.deviceShakedCounter > 0 ? true : false
                return
            }
            
            if self.countDownMusicPaused && !self.isDeviceShaked {
                //re-play count down music
                frogMngr.rePlayCountDownMusic()
                self.countDownMusicPaused = false
            }
            
            self.countDownLabel.textColor = UIColor.white
            counter -= 1
            self.frogTimeout -= 1
            
            self.generateFrogs()
            
        }
        self.countDownLabel.text = "\(Int(self.counter))"
        
    }
    
    func generateFrogs(){
        if self.frogTimeout <= 0 {
            self.frogTimeout = Int(arc4random_uniform(4) + 1)
            //remove all displayed frogs
            self.removeFrogs()
        }
        
        let c = Int(arc4random_uniform(3))
        //add random frogs
        for _ in 0...c {
            if self.pauseFrogsCounter == 0{
                let frog = frogMngr.getRandomFrog(self.bottomX, yBottom: self.bottomY)
                self.displayedFrogs.append(frog)
                
                let imgView = frog.imgView
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RandomGameController.frogImageTapped(_:)))
                imgView.isUserInteractionEnabled = true
                imgView.addGestureRecognizer(tapGestureRecognizer)
                
                imgView.zoomOut()
                self.gameBoardView.addSubview(imgView)
                imgView.zoomIn()
            }
        }

    }
    
    func removeFrogs(){
        for item in self.displayedFrogs {
            item.imgView.removeFromSuperview()
        }
        self.displayedFrogs.removeAll()
    }
    
    
    func scoreStatus(){
        isWon = true
        isLost = false
        
        if self.missed >= 3 {
            isLost = true
            isWon = false
        }
        else if RecordManager.isNewRecord(score: self.hits){
            isNewRecord = true
        }
    }
    
    
    func displayScore(){
        self.stopTimer()

        if self.countDownFlag && !self.countDownMusicPaused{
            frogMngr.stopCountDownMusic()
        }
        //display confirm
        let scoreAlert = frogMngr.getScoreAlert( score: self.hits, isWon: self.isWon, isNewRecord:isNewRecord)
        let buttonTitle = isWon ? "Go" : "Try again?"
        let saveAction = UIAlertAction(title: buttonTitle, style: .default, handler:
        {
            alert -> Void in
            if self.isWon{
                let nameTextField = scoreAlert.textFields![0] as UITextField
                //add the user record to core data
                print("firstName \(String(describing: nameTextField.text))")
            }
            
            //back to home page
            self.dismiss(animated: true, completion: nil)
        })
        scoreAlert.addAction(saveAction)
        self.present(scoreAlert, animated: true, completion: nil)

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
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if !self.isDeviceShaked && self.deviceShakedHelps > 0 {
            
            if self.countDownFlag {
                //pause count down music
                self.countDownMusicPaused = true
                frogMngr.pauseCountDownMusic()
            }
            self.isDeviceShaked = true
            self.countDownLabel.textColor = UIColor.green
            self.deviceShakedCounter = 3
            self.deviceShakedHelps-=1
            
            if self.deviceShakedHelps == 2{
                firstHelpImage.removeFromSuperview()
            }
            else if self.deviceShakedHelps == 1{
                secondHelpImage.removeFromSuperview()
            }
            else {
                thirdHelpImage.removeFromSuperview()
            }
        }
        
    }

    
}
