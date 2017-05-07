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
    var frogMngr = FrogManager()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(selectedLevel != GAME_LEVEL.HARD){
            let nextView = segue.destinationViewController as! CollectionGameController
            
            //set the values in the next view
            nextView.level = selectedLevel
        }
        self.frogMngr.stopFrogMusic()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.frogMngr.playFrogMusic()
        setButtonStyle(easyLevelBtn)
        setButtonStyle(mediumLevelBtn)
        setButtonStyle(hardlevelBtn)
    }
    
    func setButtonStyle(btn:UIButton){
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 4
        btn.layer.borderColor = UIColor.whiteColor().CGColor
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
    
    //disable landscape mode
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
}

