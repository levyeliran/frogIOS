//  ViewController.swift
//  EliranFrog
//
//  Created by Eliran Levy on 21/04/2017.
//  Copyright © 2017 Eliran Levy. All rights reserved.
//


import UIKit
import CoreLocation


class ViewController: UIViewController , CLLocationManagerDelegate{
    
    @IBOutlet weak var easyLevelBtn: UIButton!
    @IBOutlet weak var scoreBtn: UIButton!
    @IBOutlet weak var hardLevelBtn: UIButton!
    @IBOutlet weak var mediumLevelBtn: UIButton!
    
    var selectedLevel = GAME_LEVEL.none
    var frogMngr = FrogManager()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
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
        setButtonStyle(hardLevelBtn)
        setButtonStyle(scoreBtn)
        
        RecordManager.loadData()
        self.locationManager.delegate = self
        //self.initLocation()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.frogMngr.playFrogMusic()
        self.selectedLevel = GAME_LEVEL.none
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
    
    func initLocation(){
        let status  = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        if status == .denied || status == .restricted{
            //approve location
            
            //Makes sure user will be prompted again if returns to game without actually making changes
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.initLocation),
                name: .UIApplicationWillEnterForeground,
                object: nil)
            
            //pop alert
            let alert = UIAlertController(title: "Location Disabled", message: "Weak a frog would like to access to Location Services", preferredStyle: UIAlertControllerStyle.alert)
            
            //cancel
            alert.addAction(UIAlertAction(title: "No!", style: .default, handler: { _ in self.dismiss(animated: true, completion: nil)}))
            
            //Deep link, works partially due to iOS 10 related changes
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                let url = URL(string: UIApplicationOpenSettingsURLString)
                let app = UIApplication.shared
                app.open(url!, options: [:], completionHandler: nil)
            }))
            
            present(alert, animated: true, completion: nil)
        }
        
            if status == .authorizedWhenInUse {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        initLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
        print(currentLocation)
        frogMngr.updateUserLocation(location: currentLocation)
        locationManager.stopUpdatingLocation()
    }
    
    //disable landscape mode
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
}

