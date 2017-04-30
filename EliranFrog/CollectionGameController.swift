//
//  gameBoard.swift
//  EliranFrog
//
//  Created by Eliran Levy on 21/04/2017.
//  Copyright © 2017 Eliran Levy. All rights reserved.
//

import UIKit

class CollectionGameController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var hitsLabel: UILabel!
    @IBOutlet weak var missedLabel: UILabel!

    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var gameCollection: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    
    var level = GAME_LEVEL.EASY
    var frogTimeout:Int = 4
    var counter:Double = 0
    var levelInterval:Double = 1
    var frogMngr = FrogManager()
    var timer: NSTimer?
    var hits = 0
    var missed = 0
    var countDownFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.counter = level == GAME_LEVEL.EASY ? 120 : 60
        self.levelInterval = level == GAME_LEVEL.EASY ? 2 : 1
        self.frogMngr = FrogManager(level: level, xBottom: -1, yBottom: -1)
        self.gameCollection.dataSource = self
        self.gameCollection.delegate = self
        self.gameCollection.backgroundColor = UIColor.clearColor()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(levelInterval, target: self, selector: "onTimerUpdate", userInfo: nil, repeats: true)
        self.hitsLabel.text = "0"
        self.missedLabel.text = "0"
        self.countDownLabel.text = ""

    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return level == GAME_LEVEL.EASY ? 4 : 5
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("eliranFrogCell", forIndexPath: indexPath) as! CustomFrogCell
        
        cell.cellImage?.image = self.frogMngr.getDefaultImage()
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func changeCell(){
        let pos  = frogMngr.getMatrixFrogLocationOnScreen()
        if pos.x < 0 {
            //game over
        }
        else {
            let index = NSIndexPath(forRow: pos.y, inSection: pos.x)
            let cell = gameCollection.cellForItemAtIndexPath(index) as! CustomFrogCell
            let customFrog = self.frogMngr.getCustomFrogImage()
            cell.cellImage?.image = customFrog.image
            cell.isGoodFrog = customFrog.isGoodFrog
        }
    }

    //on cell click
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as! CustomFrogCell
        
        if selectedCell.isGoodFrog {
            self.hits++
            self.hitsLabel.text = "\(self.hits)"
        }
        else {
            self.missed++
            self.missedLabel.text = "\(self.missed)"
        }
        
        let cellX = indexPath.section
        let cellY = indexPath.row
        //free the pos
        self.frogMngr.frogTapped(cellX, col: cellY)
        selectedCell.cellImage?.image = self.frogMngr.getDefaultImage()
        selectedCell.isGoodFrog = false
    
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
            
            counter-=self.levelInterval
            self.frogTimeout--
            if level == GAME_LEVEL.EASY{
                self.changeCell()
            }
            else {
                for _ in 0...2 {
                    self.changeCell()
                }
            }
        }
    }
    
    func removeFrogs(){
        let displayedFrogs:[FrogPoint] = frogMngr.getDisplayedFrogPositions()
        for pos in displayedFrogs {
            let index = NSIndexPath(forRow: pos.y, inSection: pos.x)
            let cell = gameCollection.cellForItemAtIndexPath(index) as! CustomFrogCell
            cell.cellImage?.image = self.frogMngr.getDefaultImage()
        }
        frogMngr.removeAllDisplayedFrogs()
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