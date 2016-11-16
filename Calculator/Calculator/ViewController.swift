//
//  ViewController.swift
//  Calculator
//
//  Created by 최원영 on 2016. 10. 20..
//  Copyright © 2016년 최원영. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var userIsInTheMiddleOfTyping = false
    
    @IBAction func numberButtonClicked(_ sender: UIButton) {
        
        let clickedNumber = sender.currentTitle
        if userIsInTheMiddleOfTyping {
            let textCurrentInDisplay = display.text
            display.text = textCurrentInDisplay! + clickedNumber!
        } else {
            
        }
        
    }

}

