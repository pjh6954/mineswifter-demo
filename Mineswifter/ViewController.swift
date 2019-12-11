//
//  ViewController.swift
//  Mineswifter
//
//  Created by Benjamin Reynolds on 7/26/14.
//  Copyright (c) 2014 MakeGamesWithUs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    let BOARD_SIZE:Int = 10
    var board:Board
    var squareButtons:[SquareButton] = []
    
    var moves:Int = 0 {
        didSet {
            self.movesLabel.text = "Moves: \(moves)"
            self.movesLabel.sizeToFit()
        }
    }
    var timeTaken:Int = 0  {
        didSet {
            self.timeLabel.text = "Time: \(timeTaken)"
            self.timeLabel.sizeToFit()
        }
    }
    var oneSecondTimer:Timer?
    
//MARK: Initialization
    
    required init(coder aDecoder: NSCoder)
    {
        self.board = Board(size: BOARD_SIZE)
        
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initializeBoard()
        self.startNewGame()
    }
    
    func initializeBoard() {
        for row in 0 ..< board.size {
            for col in 0 ..< board.size {
                
                let square = board.squares[row][col]
                
                let squareSize:CGFloat = self.boardView.frame.width / CGFloat(BOARD_SIZE)
                
                let squareButton = SquareButton(squareModel: square, squareSize: squareSize);
                squareButton.setTitle("[x]", for: .normal)
                squareButton.setTitleColor(UIColor.darkGray, for: .normal)
                squareButton.addTarget(self, action: #selector(squareButtonPressed(sender:)), for: .touchUpInside)//"squareButtonPressed:"
                self.boardView.addSubview(squareButton)
                
                self.squareButtons.append(squareButton)
            }
        }
    }
    
    func resetBoard() {
        // resets the board with new mine locations & sets isRevealed to false for each square
        self.board.resetBoard()
        // iterates through each button and resets the text to the default value
        for squareButton in self.squareButtons {
            squareButton.setTitle("[x]", for: .normal)
        }
    }
    
    func startNewGame() {
        //start new game
        self.resetBoard()
        self.timeTaken = 0
        self.moves = 0
        self.oneSecondTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(oneSecond), userInfo: nil, repeats: true)
    }
    
    @objc func oneSecond() {
        self.timeTaken += 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: Button Actions
    
    @IBAction func newGamePressed() {
        print("new game")
        self.endCurrentGame()
        self.startNewGame()
    }
    
    @objc func squareButtonPressed(sender: SquareButton) {
//        println("Pressed row:\(sender.square.row), col:\(sender.square.col)")
//        sender.setTitle("", forState: .Normal)
        
        if !sender.square.isRevealed {
            sender.square.isRevealed = true
            sender.setTitle("\(sender.getLabelText())", for: .normal)
            self.moves += 1
        }
        
        if sender.square.isMineLocation {
            self.minePressed()
        }
    }
    
    func minePressed() {
        self.endCurrentGame()
        // show an alert when you tap on a mine
//        let alertView = UIAlertView()
//        alertView.addButton(withTitle: "New Game")
//        alertView.title = "BOOM!"
//        alertView.message = "You tapped on a mine."
//        alertView.show()
//        alertView.delegate = self
        let alertView = UIAlertController(title: "BOOM!", message: "You tapped on a mine", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "New Game", style: .default) { (alertAction) in
            self.startNewGame()
        }
        alertView.addAction(okAction)
        self.present(alertView, animated: true) {
            //
        }
    }
    
//    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
//        //start new game when the alert is dismissed
//        self.startNewGame()
//    }
    
    func endCurrentGame() {
        if oneSecondTimer != nil{
            self.oneSecondTimer!.invalidate()
            self.oneSecondTimer = nil
        }
    }


}

