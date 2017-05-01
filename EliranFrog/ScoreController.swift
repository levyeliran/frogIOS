//
//  ScoreController.swift
//  EliranFrog
//
//  Created by Eliran Levy on 01/05/2017.
//  Copyright © 2017 Eliran Levy. All rights reserved.
//

import UIKit

class ScoreController: UIViewController{
    
    @IBOutlet weak var bgImgView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var winScoreLabel: UILabel!
    
    var level = GAME_LEVEL.HARD
    var missed = 0
    var hits = 0
    var frogMngr = FrogManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.frogMngr.playFrogMusic()
        var isLoose = false
        switch self.level {
            case GAME_LEVEL.EASY:
                if missed >= 5 || hits < 10 {
                    isLoose = true
                }
                break
            default:
                if missed >= 3 || hits < 30 {
                   isLoose = true
                }
                break
        }
        
        if isLoose {
            bgImgView.backgroundColor = UIColor(patternImage: UIImage(named: "looseBG")!)
            self.winScoreLabel.text = "Again?"
        }
        else {
            bgImgView.backgroundColor = UIColor(patternImage: UIImage(named: "winBG")!)
            self.winScoreLabel.text = "\(self.hits)"
            
        }
    }
    
    
    @IBAction func onBackButtonClick(sender: AnyObject) {
        self.frogMngr.stopFrogMusic()
        performSegueWithIdentifier("homeSeg", sender: self)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
}
