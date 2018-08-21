//
//  ViewController.swift
//  ShutBox
//
//  Created by Anna Gonzalez on 8/20/18.
//  Copyright © 2018 Antonio Gonzalez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var diceLeft: UIImageView!
    @IBOutlet weak var diceRight: UIImageView!
    
    @IBOutlet weak var one: UIButton!
    @IBOutlet weak var two: UIButton!
    @IBOutlet weak var three: UIButton!
    @IBOutlet weak var four: UIButton!
    @IBOutlet weak var five: UIButton!
    @IBOutlet weak var six: UIButton!
    @IBOutlet weak var seven: UIButton!
    @IBOutlet weak var eight: UIButton!
    @IBOutlet weak var nine: UIButton!
    @IBOutlet weak var ten: UIButton!
    @IBOutlet weak var eleven: UIButton!
    @IBOutlet weak var twelve: UIButton!
    
    @IBOutlet weak var rollButton: UIButton!
    
    // Game over view and buttons
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var playerScore: UILabel!
    @IBOutlet weak var retry: UIButton!
    
    // Winner view and buttons
    @IBOutlet weak var winView: UIView!
    @IBOutlet weak var playAgainButton: UIButton!
    
    var numButtons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diceLeft.image = UIImage(named: "dice1.png")
        diceRight.image = UIImage(named: "dice2.png")
        rollButton.backgroundColor = UIColor.blue
        numButtons = [one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve]
        for button in numButtons {
            button.isEnabled = false
            button.backgroundColor = UIColor.white
        }
        innerView.isHidden = true
        retry.isEnabled = false
        winView.isHidden = true
        playAgainButton.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Generates two random numbers and reverts other buttons to previous stage. */
    @IBAction func roll(_ sender: UIButton) {
        let num1 = arc4random_uniform(6) + 1
        let num2 = arc4random_uniform(6) + 1
        
        diceLeft.image = UIImage(named: "dice\(num1).png")
        diceRight.image = UIImage(named: "dice\(num2).png")
        
        for button in numButtons {
            if (button.backgroundColor != UIColor.white && button.backgroundColor != UIColor.black) {
                button.backgroundColor = UIColor.white
            }
        }
        
        rollButton.isEnabled = false
        rollButton.backgroundColor = UIColor.black
        
        if (!highlightNumber(Int(num1 + num2))) {
            var score: Int = 0
            for button in numButtons {
                if (button.backgroundColor ==
                    UIColor.white) {
                    score += Int(button.currentTitle!)!
                }
            }
            
            innerView.isHidden = false
            playerScore.text = String(score)
            retry.isEnabled = true
        }
    }
    
    /* Marks the number buttons as already clicked */
    @IBAction func numberClicked(_ sender: UIButton) {
        let color = sender.backgroundColor
        for button in numButtons {
            if (color == button.backgroundColor!) {
                button.setTitleColor(UIColor.white, for: UIControlState(rawValue: 0))
                button.backgroundColor = UIColor.black
            }
            button.isEnabled = false
        }
        
        if (checkWin()) {
            winView.isHidden = false
            playAgainButton.isEnabled = true
        } else {
            rollButton.isEnabled = true
            rollButton.backgroundColor = UIColor.blue
        }
        
    }
    
    /* highlights the numbers that are or can add up to the rolled number
     and returns true if at least one number was highlighted */
    func highlightNumber(_ num: Int) -> Bool {
        var isHighlighted: Bool = false
        let color: [UIColor] = [UIColor.cyan, UIColor.green, UIColor.yellow, UIColor.orange, UIColor.purple, UIColor.blue]
        var numbers: [Int] = []
        for i in 1 ... (num/2) {
            if (!(num % 2 == 0 && num - i == num / 2)) {
                numbers.append(num - i)
            }
        }
        
        if (numButtons[num - 1].backgroundColor != UIColor.black) {
            numButtons[num - 1].backgroundColor = color[0]
            numButtons[num - 1].isEnabled = true
            isHighlighted = true
        }
        
        var index: Int = 1
        for n in numbers {
            if (numButtons[n - 1].backgroundColor != UIColor.black && numButtons[num - n - 1].backgroundColor != UIColor.black) {
                numButtons[n - 1].backgroundColor = color[index]
                numButtons[num - n - 1].backgroundColor = color[index]
                numButtons[n - 1].isEnabled = true
                numButtons[num - n - 1].isEnabled = true
                index += 1
                isHighlighted = true
            }
        }
        
        return isHighlighted
    }
    
    /* Checks if the game has been won. */
    func checkWin() -> Bool {
        var won: Bool = true
        for button in numButtons {
            if (button.backgroundColor != UIColor.black) {
                won = false
            }
        }
        return won
    }
    
    @IBAction func resetGame(_ sender: UIButton) {
        innerView.isHidden = true
        playerScore.text = "0"
        retry.isEnabled = false
        winView.isHidden = true
        playAgainButton.isEnabled = false
        for button in numButtons {
            button.backgroundColor = UIColor.white
            button.setTitleColor(UIColor.black, for: UIControlState(rawValue: 0))
            button.isEnabled = false
        }
        diceLeft.image = UIImage(named: "dice1.png")
        diceRight.image = UIImage(named: "dice2.png")
        rollButton.isEnabled = true
        rollButton.backgroundColor = UIColor.blue
    }
    
    
}

