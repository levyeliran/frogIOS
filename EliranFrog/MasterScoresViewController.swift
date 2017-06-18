//
//  MasterScoresViewController.swift
//  EliranFrog
//
//  Created by Matan on 17/06/2017.
//  Copyright © 2017 Eliran Levy. All rights reserved.
//

import UIKit

class MasterScoresViewController: UIViewController {
    
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    
    
    lazy var  scoresListViewController : ScoresListViewController = {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyBoard.instantiateViewController(withIdentifier: "ScoresListViewController") as! ScoresListViewController
        
        self.addViewControllerAsChildViewController(childViewController: viewController)
        
        return viewController
    }()
    
    lazy var  scoresMapViewController : ScoresMapViewController = {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyBoard.instantiateViewController(withIdentifier: "ScoresMapViewController") as! ScoresMapViewController
        
        self.addViewControllerAsChildViewController(childViewController: viewController)
        
        return viewController
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    func setupView(){
        setupSegementedController()
        updateView()
    }
    
    func updateView(){
        scoresListViewController.view.isHidden = !(segmentedController.selectedSegmentIndex == 0)
        scoresMapViewController.view.isHidden = (segmentedController.selectedSegmentIndex == 0)
    }
    
    func setupSegementedController(){
        segmentedController.removeAllSegments()
        segmentedController.insertSegment(withTitle: "List" , at: 0, animated: false)
        segmentedController.insertSegment(withTitle: "Map" , at: 1, animated: false)
        segmentedController.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
        segmentedController.selectedSegmentIndex = 0
    }

    
    func selectionDidChange(sender: UISegmentedControl){
        updateView()
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // Mark: helper method
    
    private func addViewControllerAsChildViewController(childViewController: UIViewController){
        addChildViewController(childViewController)
        view.addSubview(childViewController.view)
        
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        childViewController.didMove(toParentViewController: self)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
