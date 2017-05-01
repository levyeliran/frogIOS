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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if missed >= 3 {
            bgImgView.backgroundColor = UIColor(patternImage: UIImage(named: "looseBG")!)
            self.winScoreLabel.text = "Again?"
        }
        else {
            bgImgView.backgroundColor = UIColor(patternImage: UIImage(named: "winBG")!)
            self.winScoreLabel.text = "\(self.hits)"
            
        }
    }
    
    
    @IBAction func onBackButtonClick(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}
