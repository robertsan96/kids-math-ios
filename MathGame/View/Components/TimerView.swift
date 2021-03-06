//
//  TimerView.swift
//  MathGame
//
//  Created by Robert Sandru on 7/28/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit

protocol TimerViewDelegate: class {
    
    func timerDidEnd()
}

class TimerView: UIView {

    @IBOutlet var container: UIView!
    @IBOutlet weak var secondsLabel: UILabel!
    
    weak var delegate: TimerViewDelegate?
    
    var seconds: Int = 60
    var timer: Timer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customizeContainer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customizeContainer()
    }
    
    func customizeContainer() {
        Bundle.main.loadNibNamed("TimerView", owner: self, options: nil)
        container.frame = bounds
        addSubview(container)
        
        container.layer.cornerRadius = 15
        
        secondsLabel.text = "\(seconds)"
        startTimer()
    }
    
    @objc func timerDecrease() {
        seconds -= 1
        if seconds >= 40 {
            container.backgroundColor = UIColor.green
        } else if seconds >= 20 {
            container.backgroundColor = UIColor.orange
        } else if seconds > 0 {
            container.backgroundColor = UIColor.red
        } else if seconds == 0 {
            timer?.invalidate()
            delegate?.timerDidEnd()
        }
        secondsLabel.text = "\(seconds)"
    }
    
    func disableTimer() {
        timer?.invalidate()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerDecrease), userInfo: nil, repeats: true)
    }

}
