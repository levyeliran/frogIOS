//
//  FrogManager.swift
//  EliranFrog
//
//  Created by Eliran Levy on 21/04/2017.
//  Copyright © 2017 Eliran Levy. All rights reserved.
//

import UIKit
import AVFoundation

enum GAME_LEVEL{
    case EASY, MEDIUM, HARD
}

class FrogPoint{
    var x:Int
    var y:Int
    
    init(x:Int, y:Int){
        self.x = x
        self.y = y
    }
}

class FrogImage{
    var image: UIImage
    var isGoodFrog:Bool
    
    init(image: UIImage, isGoodFrog:Bool){
        self.image = image
        self.isGoodFrog = isGoodFrog
    }
}
class FrogImageView{
    var imgView: UIImageView
    var isGoodFrog:Bool
    
    init(imgView: UIImageView, isGoodFrog:Bool){
        self.imgView = imgView
        self.isGoodFrog = isGoodFrog
    }
}

class FrogManager{
    
    //create manager consts
    var frogWidth = 60
    var frogHeight = 60
    var easyLevelDim = 4
    var mediumLevelDim = 5
    var hardLevelCount = 50
    var displayedFrogs = 0
    
    var xBottom: Int
    var yBottom: Int
    var level: GAME_LEVEL
    var frogPositions :[FrogPoint]
    var displayedPositions :[FrogPoint]
    var audioPlayer:AVAudioPlayer
    var frogCountDownAudioPlayer:AVAudioPlayer
    
    init(){
        self.level = GAME_LEVEL.EASY
        self.xBottom = -1
        self.yBottom = -1
        self.frogPositions = [FrogPoint]()
        self.displayedPositions = [FrogPoint]()
        self.audioPlayer = AVAudioPlayer()
        self.frogCountDownAudioPlayer = AVAudioPlayer()
        
        self.initGameLevel(level)
    }
    
    init(level: GAME_LEVEL, xBottom:Int, yBottom:Int){
        self.level = level
        self.xBottom = xBottom
        self.yBottom = yBottom
        self.frogPositions = [FrogPoint]()
        self.displayedPositions = [FrogPoint]()
        self.audioPlayer = AVAudioPlayer()
        self.frogCountDownAudioPlayer = AVAudioPlayer()

        self.initGameLevel(level)
    }
    
    func initGameLevel(level: GAME_LEVEL){
        var dim = 0;
        if(level == GAME_LEVEL.EASY){
            //create easy pos cells
            dim = self.easyLevelDim
            
        }
        else if(level == GAME_LEVEL.MEDIUM){
            //create medium pos cells
            dim = self.mediumLevelDim
        }
        //hard leve is random - no meed for indexes
        for r in 0...(dim-1) {
            for c in 0...2 {
                let pos = FrogPoint(x: r,y: c)
                self.frogPositions.append(pos)
            }
        }
        //shuffle the array
        self.frogPositions.shuffle()
    }
    
    func canGetFrog() ->Bool{
        if(self.level == GAME_LEVEL.HARD){
            if(self.displayedFrogs >= self.hardLevelCount){
                return false
            }
        }
        else{
            var dim = 0
            if(self.level == GAME_LEVEL.EASY){
                dim = self.easyLevelDim*3
            }
            else {
                dim = self.mediumLevelDim*3
            }
            
            if(self.displayedFrogs >= dim){
                return false
            }
        }
        
        return true
    }
    
    func getFrogImage() -> UIImage
    {
        //random frog type
        let numRoll = Int(arc4random_uniform(10) + 1)
        let frog:UIImage
        if numRoll % 2 == 0
        {
            frog = UIImage(named: "goodFrog")!
        }
        else {
            frog = UIImage(named: "badFrog")!
        }
        return frog;
    }
    
    func getCustomFrogImage() -> FrogImage{
        //random frog type
        let numRoll = Int(arc4random_uniform(10) + 1)
        let frog:UIImage
        if numRoll % 2 == 0
        {
            frog = UIImage(named: "goodFrog")!
            return FrogImage(image: frog, isGoodFrog: true)
        }
        else {
            frog = UIImage(named: "badFrog")!
            return FrogImage(image: frog, isGoodFrog: false)
        }
    }

    
    func getRandomFrog(xBotton:Int, yBottom:Int) -> FrogImageView
    {
        let customFrog = self.getCustomFrogImage()
        let imgView = UIImageView()
        imgView.image = customFrog.image
        imgView.frame = self.getRandomFrogLocationOnScreen(xBotton,yBottom: yBottom)
        
        let frogView = FrogImageView(imgView: imgView, isGoodFrog: customFrog.isGoodFrog)
        
        self.displayedFrogs++
        return frogView
    }
    
    func getRandomFrogLocationOnScreen(xBotton:Int, yBottom:Int) -> CGRect {
        let x = Int(arc4random_uniform((UInt32(xBotton - self.frogWidth))) + 1)
        let y = Int(arc4random_uniform((UInt32(yBottom - self.frogWidth))) + 1)
        
        let rect = CGRect(x: x, y: y, width: self.frogWidth, height: self.frogHeight)
        return rect
    }
    
    func getMatrixFrogLocationOnScreen() -> FrogPoint{
        if(self.canGetFrog()){
            let pos = self.frogPositions.removeLast()
            self.displayedPositions.append(pos)
            self.displayedFrogs++
            //shuffle the array
            self.frogPositions.shuffle()
            print(pos.x, "|", pos.y)

            return pos
        }
        return FrogPoint(x: -1,y: -1)
    }
    
    func frogTapped(row:Int, col:Int){
        
        if(self.level != GAME_LEVEL.HARD){
            //add the tapped position back into the array
            self.frogPositions.append(FrogPoint(x: row, y: col))
            
            //remove from the displayed positions
            let index = self.displayedPositions.indexOf{ $0.x == row && $0.y == col }
            if index >= 0
            {
                self.displayedPositions.removeAtIndex(index!)
            }
            
            //shuffle the array
            self.frogPositions.shuffle()
        }
        self.displayedFrogs--
    }
    
    func getDefaultImage()-> UIImage{
        return UIImage(named: "default")!
    }
    
    func getDisplayedFrogPositions() -> [FrogPoint]{
        return self.displayedPositions
    }
    
    func removeAllDisplayedFrogs() -> Int{
        let displayed = self.displayedPositions.count
        for pos in self.displayedPositions{
            self.frogPositions.append(FrogPoint(x: pos.x, y: pos.y))
        }
        self.displayedPositions.removeAll()
        self.displayedFrogs = 0
        //shuffle the array
        self.frogPositions.shuffle()
        return displayed
    }
    
    func bloat(label: UILabel) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = NSNumber(float: 3)
        animation.duration = 0.5
        animation.repeatCount = 11.0
        animation.autoreverses = true
        label.textColor = UIColor.yellowColor()
        label.layer.addAnimation(animation, forKey: nil)
        self.playCountDownMusic()
    }
    
    func playFrogSound(){
        // Load "frogRibbet.wav"
        self.playSound("frogRibbet", exten: "wav", loops: 1)

    }
    
    func playCountDownMusic(){
        // Load "countdownTimer.mp3"
        self.playSound("countdownTimer", exten: "mp3", loops: 5)

    }
    
    func playFrogMusic(){
        // Load "gameMusic.mp3"
        self.playSound("gameMusic", exten: "mp3", loops: 5)
    }
    
    func playSound(fileName:String, exten:String, loops:Int){
        do {
            let sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(fileName, ofType: exten)!)
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: sound)
            self.audioPlayer.numberOfLoops = loops
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
        }
        catch {
            print("\(fileName).\(exten) can't be played")
        }

    }
    
    func stopFrogMusic(){
        self.audioPlayer.stop()
    }
    
    func stopCountDownMusic(){
        self.frogCountDownAudioPlayer.stop()
    }

    func getTargetAlert(hits:Int, miss:Int, sec:Int, okButtonHandler:(action: UIAlertAction)->Void) -> UIAlertController{
        let message = "Tap as many frogs as possible in \(sec) seconds to earn points.\nTarget: \(hits) Hits to win, avoid the Bad frog (up to \(miss))."
        let alertController = UIAlertController(title: "Level Target", message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "GO", style: .Default, handler: okButtonHandler)
        alertController.addAction(defaultAction)
        return alertController
    }
    
}

extension Array {
    mutating func shuffle() {
        if count < 2 { return }
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            if(i != j){
                swap(&self[i], &self[j])
            }
        }
    }
}
