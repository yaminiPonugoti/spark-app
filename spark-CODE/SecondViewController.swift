//
//  SecondViewController.swift
//  SPARK
//
//  Created by Sam on 4/15/18.
//  Copyright © 2018 SPARK. All rights reserved.
//

import UIKit
import AVFoundation

extension UILabel {
    
    func startBlink() {
        UIView.animate(withDuration: 0.6,
                       delay:0.4,
                       options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
                       animations: { self.alpha = 0 },
                       completion: nil)
    }
    
    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
}

class SecondViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var RedButton: UIButton!
    @IBOutlet weak var BlueButton: UIButton!
    @IBOutlet weak var GreenButton: UIButton!
    @IBOutlet weak var YellowButton: UIButton!
    
    @IBOutlet weak var RedButtonLIT: UIImageView!
    @IBOutlet weak var BlueButtonLit: UIImageView!
    @IBOutlet weak var GreenButtonLit: UIImageView!
    @IBOutlet weak var YellowButtonLit: UIImageView!
    

    @IBOutlet weak var startGame: UIButton!
    @IBOutlet weak var loseGame: UIButton!
    @IBOutlet weak var loseMsg: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreText: UILabel!
    
    var scoreCount = 1
    var highScore = Int()
    
    var player = AVAudioPlayer()
    
    var red = "RedButtonLIT"
    var blue = "BlueButtonLit"
    var green = "GreenButtonLit"
    var yellow = "YellowButtonLit"
    
    var answers = [Int]()
    var buttonsClicked = [Int]()
    
    var numTaps = 0
    var currentItem = 0
    var readyForUser = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        highScoreText.text = "1"
        setUpAudioPath()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loseGame.isHidden = true
        loseMsg.isHidden = true
        RedButtonLIT.isHidden = true
        BlueButtonLit.isHidden = true
        GreenButtonLit.isHidden = true
        YellowButtonLit.isHidden = true
        highScoreText.text = String(highScore)
    }
    
    func setUpAudioPath() {
        let soundFilePath = Bundle.main.path(forResource: "beep", ofType: "wav")
        
        do {
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: soundFilePath!) as URL)
        } catch {
            //ERROR
        }
        
        player.delegate = self
        player.numberOfLoops = 0
        
    }
    
    @IBAction func startGame(_ sender: Any) {
        currentItem = 0
        numTaps = 0
        scoreCount = 1
        highScoreText.text = String(highScore)
        
        disableButtons()
        
        let randomNumber = Int(arc4random_uniform(4) + 1)
        answers.append(randomNumber)
        
        startGame.isHidden = true
        
        displaySequence()
        //audioPlayerDidFinishPlaying(player: player, successfully: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewController
        vc.highScore = highScore
    }
    
    func nextLevel() {
        scoreCount += 1
        scoreLabel.text = String(scoreCount)
        
        if(scoreCount > highScore) {
            highScoreText.text = String(scoreCount)
            highScore = scoreCount
            
            let vc  = ViewController()
            if(vc.highScore < highScore) {
                vc.updateHighScore()
            }
            
        }
        
        numTaps = 0
        currentItem = 0
        readyForUser = false
        
        disableButtons()
        
        var randomNumber = Int(arc4random_uniform(4) + 1)
        while (randomNumber == answers[answers.count-1]) {
            randomNumber = Int(arc4random_uniform(4) + 1)
        }
        answers.append(randomNumber)
        
        displaySequence()
       // audioPlayerDidFinishPlaying(player: player, successfully: true)
        
    }
    
    func displaySequence() {
       
        let item = answers[currentItem]
        
        switch item {
        case 1:
            flash(button: 1)
            player.play()
            break
        case 2:
            flash(button: 2)
            player.play()
            break
        case 3:
            flash(button: 3)
            player.play()
            break
        case 4:
            flash(button: 4)
            player.play()
            break
        default:
            break
        }
        
        currentItem += 1
        
        var a = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            a += 1
        }
        
    }
    
    func flashLitButton(button: String) { //flashes buttons
        if(button == "RedButtonLIT") { //red button
            RedButtonLIT.isHidden = false
            RedButtonLIT.alpha = 1.0
            UIView.animate(withDuration: 0.2, delay: 0.05, animations: {
                self.RedButtonLIT.alpha = 0.0
            }) { (finished: Bool) in
                self.RedButtonLIT.isHidden = true
            }
        } else if(button == "BlueButtonLit") { //blue button
            BlueButtonLit.isHidden = false
            BlueButtonLit.alpha = 1.0
            UIView.animate(withDuration: 0.2, delay: 0.05, animations: {
                self.BlueButtonLit.alpha = 0.0
            }) { (finished: Bool) in
                self.BlueButtonLit.isHidden = true
            }
        } else if(button == "GreenButtonLit") { //green button
            GreenButtonLit.isHidden = false
            GreenButtonLit.alpha = 1.0
            UIView.animate(withDuration: 0.2, delay: 0.05, animations: {
                self.GreenButtonLit.alpha = 0.0
            }) { (finished: Bool) in
                self.GreenButtonLit.isHidden = true
            }
        } else if(button == "YellowButtonLit") { //yellow button
            YellowButtonLit.isHidden = false
            YellowButtonLit.alpha = 1.0
            UIView.animate(withDuration: 0.2, delay: 0.05, animations: {
                self.YellowButtonLit.alpha = 0.0
            }) { (finished: Bool) in
                self.YellowButtonLit.isHidden = true
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if(currentItem <= answers.count-1) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.displaySequence()
            }
        } else {
            readyForUser = true
            noFlash()
            enableButtons()
        }
    }
    
    func flash(button: Int) {
        switch button {
        case 1:
            noFlash()
            RedButton.setImage(UIImage(named: "RedButtonLit"), for: .normal)
            //break
        case 2:
            noFlash()
            BlueButton.setImage(UIImage(named: "BlueButtonLit"), for: .normal)
            //break
        case 3:
            noFlash()
            GreenButton.setImage(UIImage(named: "GreenButtonLit"), for: .normal)
            //break
        case 4:
            noFlash()
            YellowButton.setImage(UIImage(named: "YellowButtonLit"), for: .normal)
            //break
        default:
            break
        }

    }
    
    func noFlash() {
        //RedButton.setImage(UIImage(named: "RedButton"), for: .normal)
        //BlueButton.setImage(UIImage(named: "BlueButton"), for: .normal)
        //GreenButton.setImage(UIImage(named: "GreenButton"), for: .normal)
        //YellowButton.setImage(UIImage(named: "YellowButton"), for: .normal)
        
        RedButton.setImage(nil, for: .normal)
        BlueButton.setImage(nil, for: .normal)
        GreenButton.setImage(nil, for: .normal)
        YellowButton.setImage(nil, for: .normal)
        
    }

    @IBAction func buttonPressed(_ sender: Any) {
        
        if(readyForUser) {
            let button =  sender as! UIButton
        
            switch button.tag {
            case 1:
                flashLitButton(button: red)
                player.play()
                buttonsClicked.append(1)
                checkAnswers(button: 1)
                break
            case 2:
                flashLitButton(button: blue)
                player.play()
                buttonsClicked.append(1)
                checkAnswers(button: 2)
                break
            case 3:
                flashLitButton(button: green)
                player.play()
                buttonsClicked.append(1)
                checkAnswers(button: 3)
                break
            case 4:
                flashLitButton(button: yellow)
                player.play()
                buttonsClicked.append(1)
                checkAnswers(button: 4)
                break
            default:
                break
            }
        }
        
    }
    
    func checkAnswers(button: Int) {
        if(button == answers[numTaps]) {
            if(numTaps == answers.count-1) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.40) {
                    self.nextLevel()
                    
                }
                return
            }
            numTaps += 1
        } else {
            disableButtons()
            loseMsg.isHidden = false
            loseMsg.startBlink()
            loseGame.isHidden = false
        }
        
    }
    
    func enableButtons() {
        RedButton.isUserInteractionEnabled = true
        BlueButton.isUserInteractionEnabled = true
        GreenButton.isUserInteractionEnabled = true
        YellowButton.isUserInteractionEnabled = true
    }
    
    func disableButtons() {
        RedButton.isUserInteractionEnabled = false
        BlueButton.isUserInteractionEnabled = false
        GreenButton.isUserInteractionEnabled = false
        YellowButton.isUserInteractionEnabled = false
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
