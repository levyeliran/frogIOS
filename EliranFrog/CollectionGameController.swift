//
//  gameBoard.swift
//  EliranFrog
//
//  Created by Eliran Levy on 21/04/2017.
//  Copyright © 2017 Eliran Levy. All rights reserved.
//

import UIKit

class CollectionGameController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var gameCollection: UICollectionView!
    
    var level = GAME_LEVEL.EASY
    var frogMngr = FrogManager()
    //var timer =
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.frogMngr = FrogManager(level: level, xBottom: -1, yBottom: -1)
        self.gameCollection.dataSource = self
        self.gameCollection.delegate = self
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return level == GAME_LEVEL.EASY ? 4 : 5
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return level == GAME_LEVEL.EASY ? 4 : 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("eliranFrogCell", forIndexPath: indexPath) as! CustomFrogCell
        //add img here
        
        return cell
    }
    
//    func changeCell(){
//        let pos  = frogMngr.getMatrixFrogLocationOnScreen()
//        let cell = gameCollection.cellForItemAtIndexPath(NSIndexPath(forRow: pos.x, inSection: pos.y))
//        //change bkg
//    }
//    
//    //on cell click
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        let selected = gameCollection.cellForItemAtIndexPath(<#T##indexPath: NSIndexPath##NSIndexPath#>) as! CustomFrogCell
//        //check frog type
//        
//        let posX = indexPath.row
//        let posy = indexPath.section
//        //free the pos
//        //change to def bkg
//        
//        //calc score
//        
//    }
    
    //timer
    func startTimer(){
        //level seconds
        //let sec = 120
        
    
    }
    
    func eachinterval(){
        Dispat
    }
    
    
    
    
}