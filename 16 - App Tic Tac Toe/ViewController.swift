//
//  ViewController.swift
//  16 - App Tic Tac Toe
//
//  Created by Marco Linhares on 6/21/15.
//  Copyright (c) 2015 Marco Linhares. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var turn : Int = 1
    var image : UIImage = UIImage (named: "x.png")!
    var b = [String] (count: 10, repeatedValue: " ") // board
    var computerPlaying = false
    var humanPlaying = false
    var timer = NSTimer ()
    var gamePaused = false
    
    // são as sequências em que é possível ganhar a partida
    let winningCombinations = [ [1,2,3], [4,5,6], [7,8,9], // horizontal
        [1,4,7], [2,5,8], [3,6,9], // vertical
        [1,5,9], [3,5,7] ] // diagonal
    
    @IBOutlet weak var buttonPlayComputerLayout: UIButton!
    
    @IBAction func buttonRestart(sender: AnyObject) {
        restartGame ()
    }
    
    @IBAction func playComputer(sender: AnyObject) {
        computerPlaying = true
        
        buttonPlayComputerLayout.hidden = true
        
        computerPlayNextMove ()
    }
    
    @IBOutlet weak var buttonLayoutRestart: UIButton!
    
    @IBOutlet weak var imageBoard: UIImageView!
    
    @IBOutlet weak var labelWinner: UILabel!
    
    @IBAction func buttonClick(sender: AnyObject) {
        humanPlaying = true
        
        // as tags estão setadas de 1 a 9 pra ele saber qual botão usar
        // enquanto o pc está pensando, não é possível jogar
        if gamePaused == false {
            play (sender.tag)
        }
    }
    
    func play (buttonClicked : Int) {
        
        // escolhe o botão da tag específica (1 a 9)
        // com isso, não é preciso mais usar uma variável de layout
        // para cada botão e economizamos 9 variáveis
        var button = view.viewWithTag (buttonClicked) as? UIButton
        
        button!.setImage(image, forState: UIControlState.Normal)
            
        button!.userInteractionEnabled = false
        
        if turn % 2 == 0 {
            b [buttonClicked] = "o"
            
            checkWinner ("o")
            
            image = UIImage (named: "x.png")!
        } else {
            b [buttonClicked] = "x"
            
            checkWinner ("x")
            
            image = UIImage (named: "o.png")!
        }

        if turn == 2 {
            buttonPlayComputerLayout.hidden = true
        }
        
        if ++turn == 10 {
            turn = 1
        }
        
        if computerPlaying == true && humanPlaying == true {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector ("computerPlayNextMove"), userInfo: nil, repeats: false)
        }
    }
    
    func checkWinner (x : String) {
        for element in winningCombinations {
            if b[element [0]] == x && b[element [1]] == x && b[element [2]] == x {
                endGame ("\(x) wins")
                break
            } else if turn == 9 {
                endGame ("Tie Game. Try again!")
                break
            }
        }
        
        /*
        // draw lines
        
        if b [1] == x && b [2] == x && b [3] == x {
            //let button1 = view.viewWithTag (1) as? UIButton
            //let button2 = view.viewWithTag (2) as? UIButton
            //let button3 = view.viewWithTag (3) as? UIButton
        
            //CGRectMake(button1!.center.x, button1!.center.y, 300, 300)
           //CGRectMake(view.center.x - 2 * button1!.center.x, view.center.y - button1!.center.y, 300, 300)
            
        } else if b [4] == x && b [5] == x && b [6] == x {
            
        } else if b [7] == x && b [8] == x && b [9] == x {
            
        } else if b [1] == x && b [4] == x && b [7] == x {
            
        } else if b [2] == x && b [5] == x && b [8] == x {
            
        } else if b [3] == x && b [6] == x && b [9] == x {
            
        } else if b [1] == x && b [5] == x && b [9] == x {
            
        } else if b [3] == x && b [5] == x && b [7] == x {
            
        }
        */
    }
   
    func endGame (text : String) {
        labelWinner.text = text
        
        for i in 1...9 {
            var button = self.view.viewWithTag (i) as? UIButton
            
            button!.userInteractionEnabled = false
        }
        
        UIView.animateWithDuration(0.4, animations: {
            self.labelWinner.center = CGPointMake(self.labelWinner.center.x + 400, self.labelWinner.center.y )
            
            self.buttonLayoutRestart.alpha = 1
        })
        
        computerPlaying = false
    }
    
    func restartGame () {
        
        var button : UIButton?
        
        for i in 1...9 {
            button = self.view.viewWithTag (i) as? UIButton
            
            button!.userInteractionEnabled = true
            button!.setImage(nil, forState: UIControlState.Normal)
        }
        
        gamePaused = false
        
        turn = 1
        image = UIImage (named: "x.png")!
        b = [String] (count: 10, repeatedValue: " ")

        labelWinner.text = ""

        UIView.animateWithDuration(0.4, animations: {
            self.labelWinner.center = CGPointMake(self.labelWinner.center.x - 400, self.labelWinner.center.y )
            
            self.buttonLayoutRestart.alpha = 0
        })
        
        computerPlaying = false
        humanPlaying = false
        
        buttonPlayComputerLayout.hidden = false
    }
    
    func computerPlayNextMove () {
        // para que a pessoa não possa clicar enquanto o
        // computador está executando a sua jogada
        gamePaused = true
        
        humanPlaying = false
       
        if turn % 2 == 0 {
            computerLogic ("o")
        } else {
            computerLogic ("x")
        }
        
        // locker destravado por jogo continuar
        gamePaused = false
    }
    
    func computerLogic (x : String) {
        if tryToWin (x) == false {
            if tryToBlock (x) == false {
                moveBestPlace (x)
            }
        }
    }
    
    // esse código foi feito economizar várias linhas com ifs de comparações, que agora são feitas no for
    func tryToWin (x : String) -> Bool {
        // nos turnos 2 e 3 a melhor jogada é geralmente no meio, por isso força o pc a fazer essa jogada
        if (turn == 2 /*|| turn == 3*/) && b [5] == " " {

            play (5)
            return true
            
        } else {
            for element in winningCombinations {
                if b[element [0]] == x && b[element [1]] == x && b[element [2]] == " " {
                
                    play (element [2])
                    return true
                
                } else if b[element [0]] == " " && b[element [1]] == x && b[element [2]] == x {
                
                    play (element [0])
                    return true
                
                } else if b[element [0]] == x && b[element [1]] == " " && b[element [2]] == x {

                    play (element [1])
                    return true
                }
            }
        }
            
        return false
    }

// a função cria um vetor de structs para armazenar tanto o valor do vetor quanto o seu índice
//    comentada para tentar fazer depois trocando struct por uma classe
//    func tryToWin (x : String) -> Bool {
//        
//        struct Board {
//            var b : String
//            var index : Int
//        }
//        
//        var v : [Board] = []
//        
//        // atualiza o vetor com os valores marcados, o índice 0 não é usado
//        for i in 0...9 {
//            v.append(Board(b: b[i], index: i))
//        }
//        
//        let winningCombinations = [ [v[1],v[2],v[3]], [v[4],v[5],v[6]], [v[7],v[8],v[9]], // horizontal
//            [v[1],v[4],v[7]], [v[2],v[5],v[8]], [v[3],v[6],v[9]], // vertical
//            [v[1],v[5],v[9]], [v[3],v[5],v[7]] ] // diagonal
//        
//        // nos turnos 2 e 3 a melhor jogada é geralmente no meio, por isso força o pc a fazer essa jogada
//        if (turn == 2 /*|| turn == 3*/) && b [5] == " " {
//            play (5)
//            
//            return true
//        } else {
//            for element in winningCombinations {
//                if element [0].b == x && element [1].b == x && element [2].b == " " {
//                    
//                    play (element [2].index)
//                    return true
//                    
//                } else if element [0].b == " " && element [1].b == x && element [2].b == x {
//                    
//                    play (element [0].index)
//                    return true
//                    
//                } else if element [0].b == x && element [1].b == " " && element [2].b == x {
//                    
//                    play (element [1].index)
//                    return true
//                }
//            }
//        }
//        
//        return false
//    }

    // tentar bloquear um jogador é exatamente igual a tentar ganhar com o valor contrário
    func tryToBlock (x : String) -> Bool {
        if x == "o" {
            return tryToWin("x")
        } else {
            return tryToWin("o")
        }
    }
    
    func moveBestPlace (x : String) {
        if b [1] == " " && ( (b [3] == x && b [9] == x) ||
                             (b [3] == x && b [7] == x) ||
                             (b [7] == x && b [9] == x) ) {
            play (1)
        } else if b [3] == " " && ( (b [1] == x && b [9] == x) ||
                                    (b [1] == x && b [7] == x) ||
                                    (b [7] == x && b [9] == x) ) {
            play (3)
        } else if b [7] == " " && ( (b [1] == x && b [9] == x) ||
                                    (b [1] == x && b [3] == x) ||
                                    (b [3] == x && b [9] == x) ) {
            play (7)
        } else if b [9] == " " && ( (b [1] == x && b [3] == x) ||
                                    (b [1] == x && b [7] == x) ||
                                    (b [7] == x && b [3] == x) ) {
            play (9)
        } else if tryToWin (" ") == false {
            // como ninguém tem 3 disponíveis, não dá pra ganhar, então joga random
            // FALSO!!!! Na verdade dá pra melhorar essa parte do algoritmo!
            for var i = 1; i <= 9; i++ {
                if b [i] == " " {
                    play (i)
                    
                    break
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        restartGame ()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

