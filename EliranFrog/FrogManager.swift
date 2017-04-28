//
//  FrogManager.swift
//  EliranFrog
//
//  Created by Eliran Levy on 21/04/2017.
//  Copyright © 2017 Eliran Levy. All rights reserved.
//

import UIKit

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

class FrogManager{
    
    //create manager consts
    var frogWidth = 30
    var frogHeight = 30
    var easyLevelDim = 4
    var mediumLevelDim = 5
    var hardLevelCount = 50
    var displayedFrogs = 0
    
    var xBottom: Int
    var yBottom: Int
    var level: GAME_LEVEL
    var frogPositions :[FrogPoint]
    
    init(){
        self.level = GAME_LEVEL.EASY
        self.xBottom = -1
        self.yBottom = -1
        self.frogPositions = [FrogPoint]()
        self.initGameLevel(level)
    }
    
    init(level: GAME_LEVEL, xBottom:Int, yBottom:Int){
        self.level = level
        self.xBottom = xBottom
        self.yBottom = yBottom
        self.frogPositions = [FrogPoint]()
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
        
        for r in 0...dim {
            for c in 0...dim {
                let pos = FrogPoint(x: r,y: c)
                self.frogPositions.append(pos)
            }
        }
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
                dim = self.easyLevelDim*2
            }
            else {
                dim = self.mediumLevelDim*2
            }
            
            if(self.displayedFrogs >= dim){
                return false
            }
        }
        
        return true
    }
    
    func getFrogImage() -> UIImageView
    {
        //random frog type
        let numRoll = Int(arc4random_uniform(10) + 1)
        let frog = UIImageView()
        if numRoll % 2 == 0
        {
            frog.image = UIImage(named: "goodFrog")
        }
        else {
            frog.image = UIImage(named: "badFrog")
        }
        return frog;
    }

    
    func getRandomFrog(xBotton:Int, yBottom:Int) -> UIImageView
    {
        let frog = self.getFrogImage();
        frog.frame = self.getRandomFrogLocationOnScreen(xBotton,yBottom: yBottom)
        self.displayedFrogs++
        return frog
    }
    
    func getRandomFrogLocationOnScreen(xBotton:Int, yBottom:Int) -> CGRect {
        let x = Int(arc4random_uniform((UInt32(xBotton - self.frogWidth))) + 1)
        let y = Int(arc4random_uniform((UInt32(yBottom - self.frogWidth))) + 1)
        
        let rect = CGRect(x: x, y: y, width: self.frogWidth, height: self.frogHeight)
        return rect
    }
    
    func getMatrixFrogLocationOnScreen() -> FrogPoint{
        if(self.canGetFrog()){
            let pos = self.frogPositions.removeLast();
            self.displayedFrogs++
            return pos
        }
        return FrogPoint(x: -1,y: -1)
    }
    
    func frogTapped(row:Int, col:Int){
        
        if(self.level != GAME_LEVEL.HARD){
            //add the tapped position back into the array
            self.frogPositions.append(FrogPoint(x: row, y: col))
            //shuffle the array
            self.frogPositions.shuffle()
        }
        self.displayedFrogs--
    }
    
}

extension Array {
    mutating func shuffle() {
        if count < 2 { return }
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swap(&self[i], &self[j])
        }
    }
}
