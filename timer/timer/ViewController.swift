//
//  ViewController.swift
//  timer
//
//  Created by Rafael Oliveira on 23/06/18.
//  Copyright © 2018 Rafael Oliveira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var time = 0
    var timer = Timer()
    
    @IBOutlet weak var screen: UILabel!
    
    @IBAction func start_btn(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ViewController.action), userInfo: nil, repeats: true)
    }
    
    @IBAction func pause_btn(_ sender: Any) {
        timer.invalidate()
    }
    
    @IBAction func reset_btn(_ sender: Any) {
        timer.invalidate()
        time = 0
        screen.text = "0"
    }
    
    @objc func action(){
        time += 1
        screen.text = String(time)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
}

