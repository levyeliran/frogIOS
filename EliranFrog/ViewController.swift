//
//  ViewController.swift
//  EliranFrog
//
//  Created by Eliran Levy on 21/04/2017.
//  Copyright © 2017 Eliran Levy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
   
    
    var selectedLevel = GAME_LEVEL.none
    var frogMngr = FrogManager()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(selectedLevel != GAME_LEVEL.none){
        if(selectedLevel != GAME_LEVEL.hard){
            let nextView = segue.destination as! CollectionGameController
            
            //set the values in the next view
            nextView.level = selectedLevel
        }
        }
        self.frogMngr.stopFrogMusic()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.frogMngr.playFrogMusic()
        setButtonStyle(easyLevelBtn)
        setButtonStyle(mediumLevelBtn)
        setButtonStyle(hardlevelBtn)
        setButtonStyle(scoresBtn)
    }
    
    func setButtonStyle(_ btn:UIButton){
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 4
        btn.layer.borderColor = UIColor.white.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func easyBtnClick(_ sender: UIButton) {
        initSeg(GAME_LEVEL.easy)
    }
    
    
    @IBAction func mediumBtnClick(_ sender: AnyObject) {
        initSeg(GAME_LEVEL.medium)
    }
    
    
    @IBAction func hardBtnClick(_ sender: AnyObject) {
        initSeg(GAME_LEVEL.hard)
    }
    
    
    @IBAction func scoresBtnClick(_ sender: Any) {
        performSegue(withIdentifier: "scoreSeg", sender: self)
    }
    
    fileprivate func initSeg(_ level:GAME_LEVEL){
        selectedLevel = level
        if(selectedLevel != GAME_LEVEL.hard){
            performSegue(withIdentifier: "collectionSeg", sender: self)
            
        }
        else{
            performSegue(withIdentifier: "viewSeg", sender: self)
        }
    }
    
    //disable landscape mode
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
}

