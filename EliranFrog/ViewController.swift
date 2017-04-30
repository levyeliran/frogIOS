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
        
        easyLevelBtn.layer.cornerRadius = 5
        easyLevelBtn.layer.borderWidth = 4
        easyLevelBtn.layer.borderColor = UIColor.whiteColor().CGColor
        
        mediumLevelBtn.layer.cornerRadius = 5
        mediumLevelBtn.layer.borderWidth = 4
        mediumLevelBtn.layer.borderColor = UIColor.whiteColor().CGColor
        
        hardlevelBtn.layer.cornerRadius = 5
        hardlevelBtn.layer.borderWidth = 4
        hardlevelBtn.layer.borderColor = UIColor.whiteColor().CGColor
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
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
}

