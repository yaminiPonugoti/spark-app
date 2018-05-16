//
//  ViewController.swift
//  SPARK
//
//  Created by Sam on 4/15/18.
//  Copyright © 2018 SPARK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var playBttn: UIButton!
    @IBOutlet weak var helpBttn: UIButton!
    
    var highScore = UserDefaults.standard.integer(forKey: "score")
    let highScoreDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateHighScore()
        
        highScoreDefault.set(highScore, forKey: "score")
        let value = highScoreDefault.integer(forKey: "score")
        highScoreLabel.text = String(value)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        updateHighScore()
        
        let score = highScore
        
        if(highScoreDefault.value(forKey: "score") != nil) {
            highScore = highScoreDefault.integer(forKey: "score")
            highScoreLabel.text = String(score)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let button = sender as! UIButton
        
        if(button.tag == 1) {
        _ = segue.destination as! ThirdViewController
        } else {
        
        let vc = segue.destination as! SecondViewController
        vc.highScore = highScore
        
        let score = highScore

        highScoreDefault.set(score, forKey: "score")
        highScoreDefault.synchronize()
        
        if(highScoreDefault.value(forKey: "score") != nil) {
            highScore = highScoreDefault.integer(forKey: "score")
            highScoreLabel.text = String(score)
        }
        }
        
    }
    
    func updateHighScore() {
        let vc = SecondViewController()
        if(vc.highScore > highScore) {
            highScore = vc.highScore
        }
        
        let score = highScore
        
//        var score = UserDefaults.standard.integer(forKey: "score") {
//            didSet {
//                //print("Saving isOffline flag which is now \(isOffline)")
//                UserDefaults.standard.set(highScore, forKey: "score")
//                UserDefaults.standard.synchronize()
//            }
//        }
        
        highScoreDefault.set(score, forKey: "score")
        highScoreDefault.synchronize()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

