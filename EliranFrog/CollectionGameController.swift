//
//  gameBoard.swift
//  EliranFrog
//
//  Created by Eliran Levy on 21/04/2017.
//  Copyright © 2017 Eliran Levy. All rights reserved.
//

import UIKit
import AudioToolbox.AudioServices


class CollectionGameController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var hitsLabel: UILabel!
    @IBOutlet weak var missedLabel: UILabel!

    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var gameCollection: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var firstHelpImage: UIImageView!
    @IBOutlet weak var secondHelpImage: UIImageView!
    @IBOutlet weak var thirdHelpImage: UIImageView!
    
    var level = GAME_LEVEL.easy
    var frogTimeout:Int = 4
    var counter:Int = 60
    var levelInterval:Int = 1
    var frogMngr = FrogManager()
    var timer: Timer?
    var hits = 0
    var missed = 0
    var countDownFlag = false
    var numOfRows = 0
    var numOfCols = 0
    var isWon = false
    var isLost = false
    var pauseFrogsCounter = 0
    var isDeviceShaked = false
    var deviceShakedHelps = 3
    var deviceShakedCounter = 0
    var countDownMusicPaused = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.levelInterval = 1
        self.frogMngr = FrogManager(level: level, xBottom: -1, yBottom: -1)
        self.gameCollection.dataSource = self
        self.gameCollection.delegate = self
        self.gameCollection.backgroundColor = UIColor.clear
        
        self.hitsLabel.text = "0"
        self.missedLabel.text = "0"
        self.countDownLabel.text = ""
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            //get alert object
            let targetAlert:UIAlertController = self.frogMngr.getTargetAlert(level == GAME_LEVEL.easy ? 10 : 30, miss: level == GAME_LEVEL.easy ? 5 : 3, sec: Int(self.counter) ,okButtonHandler: { (action) -> Void in
                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.levelInterval), target: self, selector: #selector(CollectionGameController.onTimerUpdate), userInfo: nil, repeats: true)
            })
            //display the alert
            self.present(targetAlert, animated: true, completion: nil)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        self.numOfRows = Int((screenHeight-100)/95)
        self.numOfCols = Int(screenWidth / 95)
        
        self.frogMngr.numOfRows = self.numOfRows
        self.frogMngr.numOfCols = self.numOfCols
        self.frogMngr.initGameLevel()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfCols
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eliranFrogCell", for: indexPath) as! CustomFrogCell
        
        cell.cellImage?.image = self.frogMngr.getDefaultImage()
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func changeCell(){
        let pos  = frogMngr.getMatrixFrogLocationOnScreen()
        if pos.x < 0 {
            //game over
        }
        else if(frogMngr.canGetFrog()){
                let index = IndexPath(row: pos.y, section: pos.x)
                let cell = gameCollection.cellForItem(at: index) as! CustomFrogCell
            
                cell.zoomOut()
            
                let customFrog = self.frogMngr.getCustomFrogImage()
                cell.cellImage?.image = customFrog.image
                cell.isGoodFrog = customFrog.isGoodFrog
            
                cell.zoomIn()
        }
    }

    //on cell click
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! CustomFrogCell
        
        if selectedCell.isGoodFrog {
            self.frogMngr.playFrogSound()
            self.hits += 1
            self.hitsLabel.text = "\(self.hits)"
        }
        else {
            self.pauseFrogsCounter = 3
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.missed += 1
            self.missedLabel.text = "\(self.missed)"
        }
        
        let cellX = indexPath.section
        let cellY = indexPath.row
        
        selectedCell.isGoodFrog = false
        selectedCell.zoomOut()
        
        //free the pos
        self.frogMngr.frogTapped(cellX, col: cellY)
        selectedCell.cellImage?.image = self.frogMngr.getDefaultImage()
        
        selectedCell.zoomIn()
        selectedCell.rotate()
        
        //calculate score
        self.scoreStatus()
        
    }
    
    
    func onTimerUpdate(){
        if self.counter <= 0 {
            self.countDownLabel.text = " "
            self.stopTimer()
            //remove all displayed frogs
            self.removeFrogs()
            self.counter = 0
            self.frogMngr.stopCountDownMusic()
            self.countDownLabel.removeFromSuperview()
            //display score
            self.displayScore()
        }
        else {
            if self.counter <= 11 {
                
                if self.pauseFrogsCounter > 0 {
                    self.countDownLabel.textColor = UIColor.red
                    self.pauseFrogsCounter-=1
                    counter-=self.levelInterval
                    self.countDownLabel.text = "\(Int(self.counter))"
                    return
                }
                
                if !self.countDownFlag{
                    self.countDownFlag = true
                    self.frogMngr.bloat(self.countDownLabel)
                }
            }
            
            if self.frogTimeout <= 0 {
                self.frogTimeout = 4
                //remove all displayed frogs
                self.removeFrogs()
            }
            
            if self.pauseFrogsCounter > 0 {
                self.countDownLabel.textColor = UIColor.red
                self.pauseFrogsCounter-=1
                counter-=self.levelInterval
                self.countDownLabel.text = "\(Int(self.counter))"
                return
            }
            
            if self.isDeviceShaked && self.deviceShakedCounter > 0 {
                self.deviceShakedCounter-=1
                self.isDeviceShaked = self.deviceShakedCounter > 0 ? true : false
                return
            }
            
            if self.countDownMusicPaused && !self.isDeviceShaked {
                //re-play count down music
                frogMngr.rePlayCountDownMusic()
                self.countDownMusicPaused = false
            }

            if level == GAME_LEVEL.easy {
                self.changeCell()
            }
            else  {
                for _ in 0...2 {
                    if self.pauseFrogsCounter == 0 {
                        self.changeCell()
                    }
                }
            }
            self.countDownLabel.textColor = UIColor.white
            self.frogTimeout -= 1
            counter-=self.levelInterval
        }
        self.countDownLabel.text = "\(Int(self.counter))"

    }
    
    func removeFrogs(){
        let displayedFrogs:[FrogPoint] = frogMngr.getDisplayedFrogPositions()
        for pos in displayedFrogs {
            let index = IndexPath(row: pos.y, section: pos.x)
            let cell = gameCollection.cellForItem(at: index) as! CustomFrogCell
            cell.isGoodFrog = false
            cell.cellImage?.image = self.frogMngr.getDefaultImage()
        }
        frogMngr.removeAllDisplayedFrogs()
    }
    
    func scoreStatus(){
        
        if self.level == GAME_LEVEL.easy {
            if self.hits >= 10 {
                isWon = true
            }
            else if self.missed >= 5 {
                isLost = true
            }
        }
        else {
            if self.hits >= 30 {
                isWon = true
            }
            else if self.missed >= 3 {
                isLost = true
            }
        }
        
        if (isWon || isLost){
            self.displayScore()
        }
    }
    
    func displayScore(){
        self.stopTimer()
        if self.countDownFlag && !self.countDownMusicPaused{
            frogMngr.stopCountDownMusic()
        }
        //display confirm
        var isNewRecord = false

        if self.isWon {
            isNewRecord = true
            
        }
        
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
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {

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
