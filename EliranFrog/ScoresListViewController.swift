//
//  ScoresListViewController.swift
//  EliranFrog
//
//  Created by Matan on 17/06/2017.
//  Copyright © 2017 Eliran Levy. All rights reserved.
//

import UIKit

class ScoresListViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {

    
    let list =  ["hey", "how" , "bye","hey", "how" , "bye","hey", "how" , "bye","hey", "how" , "bye"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (list.count)
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.default , reuseIdentifier: "scoreCell")
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
