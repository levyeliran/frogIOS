//
//  FrogManager.swift
//  EliranFrog
//
//  Created by Eliran Levy on 21/04/2017.
//  Copyright © 2017 Eliran Levy. All rights reserved.
//

import UIKit
import AVFoundation
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


enum GAME_LEVEL{
    case none, easy, medium, hard
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
    var hardLevelCount = 50
    var displayedFrogs = 0
    
    var xBottom: Int
    var yBottom: Int
    var level: GAME_LEVEL
    var frogPositions :[FrogPoint]
    var displayedPositions :[FrogPoint]
    var audioPlayer:AVAudioPlayer
    var frogCountDownAudioPlayer:AVAudioPlayer
    var numOfRows = 0
    var numOfCols = 0
    
    init(){
        self.level = GAME_LEVEL.easy
        self.xBottom = -1
        self.yBottom = -1
        self.frogPositions = [FrogPoint]()
        self.displayedPositions = [FrogPoint]()
        self.audioPlayer = AVAudioPlayer()
        self.frogCountDownAudioPlayer = AVAudioPlayer()
        
        //self.initGameLevel(level: level)
    }
    
    //collection view level
    init(level: GAME_LEVEL, posRows:Int, posCols:Int){
        self.level = GAME_LEVEL.easy
        self.xBottom = -1
        self.yBottom = -1
        self.frogPositions = [FrogPoint]()
        self.displayedPositions = [FrogPoint]()
        self.audioPlayer = AVAudioPlayer()
        self.frogCountDownAudioPlayer = AVAudioPlayer()
        self.numOfRows = posRows
        self.numOfCols = posCols
        
        //self.initGameLevel(level: level)
    }
    
    //random view level
    init(level: GAME_LEVEL, xBottom:Int, yBottom:Int){
        self.level = level
        self.xBottom = xBottom
        self.yBottom = yBottom
        self.frogPositions = [FrogPoint]()
        self.displayedPositions = [FrogPoint]()
        self.audioPlayer = AVAudioPlayer()
        self.frogCountDownAudioPlayer = AVAudioPlayer()

        //self.initGameLevel(level: level)
    }
    
    func initGameLevel(){
        if(self.level == GAME_LEVEL.easy || self.level == GAME_LEVEL.medium){
            
            for r in 0...(self.numOfRows-1) {
                for c in 0...(self.numOfCols-1) {
                    let pos = FrogPoint(x: r,y: c)
                    self.frogPositions.append(pos)
                }
            }
            //shuffle the array
            self.frogPositions.shuffle()
        }
        //hard leve is random - no need for indexes
    }
    
    func canGetFrog() ->Bool{
        if(self.level == GAME_LEVEL.hard){
            if(self.displayedFrogs >= self.hardLevelCount){
                return false
            }
        }
        else{
            let dim = self.numOfCols*self.numOfRows
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

    
    func getRandomFrog(_ xBotton:Int, yBottom:Int) -> FrogImageView
    {
        let customFrog = self.getCustomFrogImage()
        let imgView = UIImageView()
        imgView.image = customFrog.image
        imgView.frame = self.getRandomFrogLocationOnScreen(xBotton,yBottom: yBottom)
        
        let frogView = FrogImageView(imgView: imgView, isGoodFrog: customFrog.isGoodFrog)
        
        self.displayedFrogs += 1
        return frogView
    }
    
    func getRandomFrogLocationOnScreen(_ xBotton:Int, yBottom:Int) -> CGRect {
        let x = Int(arc4random_uniform((UInt32(xBotton - self.frogWidth))) + 1)
        let y = Int(arc4random_uniform((UInt32(yBottom - self.frogWidth))) + 1)
        
        let rect = CGRect(x: x, y: y, width: self.frogWidth, height: self.frogHeight)
        return rect
    }
    
    func getMatrixFrogLocationOnScreen() -> FrogPoint{
        if(self.canGetFrog()){
            let pos = self.frogPositions.removeLast()
            self.displayedPositions.append(pos)
            self.displayedFrogs += 1

            return pos
        }
        return FrogPoint(x: -1,y: -1)
    }
    
    func frogTapped(_ row:Int, col:Int){
        
        if(self.level != GAME_LEVEL.hard){
            //add the tapped position back into the array
            self.frogPositions.append(FrogPoint(x: row, y: col))
            
            //remove from the displayed positions
            let index = self.displayedPositions.index{ $0.x == row && $0.y == col }
            if index >= 0
            {
                self.displayedPositions.remove(at: index!)
            }
            
            //shuffle the array
            self.frogPositions.shuffle()
        }
        self.displayedFrogs -= 1
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
    
    //count down animation
    func bloat(_ label: UILabel) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = NSNumber(value: 3 as Float)
        animation.duration = 0.5
        animation.repeatCount = 11.0
        animation.autoreverses = true
        label.textColor = UIColor.yellow
        label.layer.add(animation, forKey: nil)
        self.playCountDownMusic()
    }
    
    
    func playFrogSound(){
        // Load "frogRibbet.wav"
        do {
            let frogSound = URL(fileURLWithPath: Bundle.main.path(forResource: "frogRibbet", ofType: "wav")!)
            self.audioPlayer = try AVAudioPlayer(contentsOf: frogSound)
            self.audioPlayer.numberOfLoops = 1
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
        }
        catch {
            print("frogRibbet.wav can't be played")
        }
    }
    
    func playCountDownMusic(){
        // Load "countdownTimer.mp3"
        do {
            let frogSound = URL(fileURLWithPath: Bundle.main.path(forResource: "countdownTimer", ofType: "mp3")!)
            self.frogCountDownAudioPlayer = try AVAudioPlayer(contentsOf: frogSound)
            self.frogCountDownAudioPlayer.numberOfLoops = 5
            self.frogCountDownAudioPlayer.prepareToPlay()
            self.frogCountDownAudioPlayer.play()
        }
        catch {
            print("countdownTimer.mp3 can't be played")
        }
    }
    
    func playFrogMusic(){
        // Load "gameMusic.mp3"
        do {
            let frogSound = URL(fileURLWithPath: Bundle.main.path(forResource: "gameMusic", ofType: "mp3")!)
            self.audioPlayer = try AVAudioPlayer(contentsOf: frogSound)
            self.audioPlayer.numberOfLoops = 5
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
        }
        catch {
            print("gameMusic.mp3 can't be played")
        }
    }
    
    func stopFrogMusic(){
        self.audioPlayer.stop()
    }
    
    func stopCountDownMusic(){
        self.frogCountDownAudioPlayer.stop()
    }

    func getTargetAlert(_ hits:Int, miss:Int, sec:Int, okButtonHandler:@escaping (_ action: UIAlertAction)->Void) -> UIAlertController{
        let message = "Tap as many frogs as possible in \(sec) seconds to earn points.\nTarget: \(hits) Hits to win, avoid the Bad frog (up to \(miss))."
        let alertController = UIAlertController(title: "Level Target", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "GO", style: .default, handler: okButtonHandler)
        alertController.addAction(defaultAction)
        return alertController
    }
    
    
    
    
    
    //Eliran Area
    
    //tap on a bad frog - pause the frog appearence
    //limit to 1 minute
    //score according to fruit ninja
    //add "best score" of user
    //add animation to frog image
    //add dialog to the end of the game + input
    //pause images when the user shake the phone (up to 3 times)
    
    
    //Matan Area
    //function - getBestScore()
    //function - getRecordPosition(score)
    //function - isNewRecord(score)
    //function - addNewRecord(name, score) - get permission for location
    //scores view
    //map view
    //storage
    
    
    
    
    
    
    
    
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