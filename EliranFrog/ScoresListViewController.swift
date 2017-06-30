//
//  ScoresListViewController.swift
//  EliranFrog
//
//  Created by Matan on 17/06/2017.
//  Copyright © 2017 Eliran Levy. All rights reserved.
//

import UIKit

class ScoresListViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {

    
    @IBOutlet weak var scoreTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreTable.delegate = self
        scoreTable.dataSource = self
        
        let backgroundImage = UIImage(named: "welcomeBG.png")
        let imageView = UIImageView(image: backgroundImage)
        self.scoreTable.backgroundView = imageView

    }

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (RecordManager.recordList.count)
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
       let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath) as! MyTableViewCell
        
        cell.userNameLabel?.text = RecordManager.recordList[indexPath.row].playerName
        cell.scoreLabel?.text = RecordManager.recordList[indexPath.row].score?.description
        cell.positionLabel?.text = "\(indexPath.row + 1)."
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
