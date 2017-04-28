//
//  ViewController.swift
//  EliranFrog
//
//  Created by Eliran Levy on 21/04/2017.
//  Copyright © 2017 Eliran Levy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var easyLevelBtn: UIButton!
    @IBOutlet weak var mediumLevelBtn: UIButton!
    @IBOutlet weak var hardlevelBtn: UIButton!
    var selectedLevel = GAME_LEVEL.EASY
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(selectedLevel != GAME_LEVEL.HARD){
            let nextView = segue.destinationViewController as! CollectionGameController
            nextView.level = selectedLevel
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func easyBtnClick(sender: UIButton) {
        initSeg(GAME_LEVEL.EASY)
    }
    
    
    @IBAction func mediumBtnClick(sender: AnyObject) {
        initSeg(GAME_LEVEL.MEDIUM)
    }
    
    
    @IBAction func hardBtnClick(sender: AnyObject) {
        initSeg(GAME_LEVEL.HARD)
    }
    
    private func initSeg(level:GAME_LEVEL){
        selectedLevel = level
        if(selectedLevel != GAME_LEVEL.HARD){
            performSegueWithIdentifier("collectionSeg", sender: self)
        }
        else{
            performSegueWithIdentifier("viewSeg", sender: self)
        }
    }
    
}

