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
    
    var level = GAME_LEVEL.hard
    var missed = 0
    var hits = 0
    var frogMngr = FrogManager()
    var relativeVerticalOffset:Float = 500/1300; //label location in the original image
    var relativeHorizontalOffset:Float = 500/768; //label location in the original image
    let screenSize: CGSize = UIScreen.main.bounds.size

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.frogMngr.playFrogMusic()
        var isLoose = false
        switch self.level {
            case GAME_LEVEL.easy:
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
        let frame = CGRect(x: 20, y: CGFloat(Float(screenSize.height)*self.relativeVerticalOffset),width: 115, height: 50)
        winScoreLabel.frame = frame
        
        if isLoose {
            bgImgView.backgroundColor = UIColor(patternImage: UIImage(named: "looseBG")!)
            self.winScoreLabel.text = "Again?"
        }
        else {
            bgImgView.backgroundColor = UIColor(patternImage: UIImage(named: "winBG")!)
            self.winScoreLabel.text = "\(self.hits)"
            
        }
        self.dismiss(animated: true, completion: nil)

    }
    
    
    @IBAction func onBackButtonClick(_ sender: AnyObject) {
        self.frogMngr.stopFrogMusic()
        self.dismiss(animated: true, completion: {})

    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
}
