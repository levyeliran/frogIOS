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
    
    var level = GAME_LEVEL.easy
    var frogTimeout:Int = 4
    var counter:Double = 0
    var levelInterval:Double = 1
    var frogMngr = FrogManager()
    var timer: Timer?
    var hits = 0
    var missed = 0
    var countDownFlag = false
    var numOfRows = 0
    var numOfCols = 0
    
    var shouldDisappear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.counter = level == GAME_LEVEL.easy ? 120 : 60
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
        if !shouldDisappear {
            //get alert object
            let targetAlert:UIAlertController = self.frogMngr.getTargetAlert(level == GAME_LEVEL.easy ? 10 : 30, miss: level == GAME_LEVEL.easy ? 5 : 3, sec: Int(self.counter) ,okButtonHandler: { (action) -> Void in
                self.timer = Timer.scheduledTimer(timeInterval: self.levelInterval, target: self, selector: #selector(CollectionGameController.onTimerUpdate), userInfo: nil, repeats: true)
            })
            //display the alert
            self.present(targetAlert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shouldDisappear {
            self.dismiss(animated: false, completion: {})
        }
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        numOfRows = Int((screenHeight-100)/106)
        numOfCols = Int(screenWidth / 106)
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
        else {
            let index = IndexPath(row: pos.y, section: pos.x)
            let cell = gameCollection.cellForItem(at: index) as! CustomFrogCell
            let customFrog = self.frogMngr.getCustomFrogImage()
            cell.cellImage?.image = customFrog.image
            cell.isGoodFrog = customFrog.isGoodFrog
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
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.missed += 1
            self.missedLabel.text = "\(self.missed)"
        }
        
        let cellX = indexPath.section
        let cellY = indexPath.row
        
        //free the pos
        self.frogMngr.frogTapped(cellX, col: cellY)
        selectedCell.cellImage?.image = self.frogMngr.getDefaultImage()
        selectedCell.isGoodFrog = false
        
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
                }            }
            
            if self.frogTimeout <= 0 {
                self.frogTimeout = 4
                //remove all displayed frogs
                self.removeFrogs()
            }
            
            counter-=self.levelInterval
            self.frogTimeout -= 1
            if level == GAME_LEVEL.easy{
                self.changeCell()
            }
            else {
                for _ in 0...2 {
                    self.changeCell()
                }
            }
        }
        self.countDownLabel.text = "\(Int(self.counter))"

    }
    
    func removeFrogs(){
        let displayedFrogs:[FrogPoint] = frogMngr.getDisplayedFrogPositions()
        for pos in displayedFrogs {
            let index = IndexPath(row: pos.y, section: pos.x)
            let cell = gameCollection.cellForItem(at: index) as! CustomFrogCell
            cell.cellImage?.image = self.frogMngr.getDefaultImage()
        }
        frogMngr.removeAllDisplayedFrogs()
    }
    
    func scoreStatus(){
        var isWon = false
        var isLost = false
        
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
