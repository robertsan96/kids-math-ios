//
//  GameTVC.swift
//  MathGame
//
//  Created by Robert Sandru on 7/28/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit

protocol GameTVCDelegate: class {
    
    func didPressInfo(on cell: GameTVC)
}

class GameTVC: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gameName: UILabel!
    
    var game: Game = .adding
    
    weak var delegate: GameTVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            containerView.alpha = 1
            containerView.layer.borderWidth = 5
            containerView.layer.borderColor = UIColor.black.cgColor
            backgroundColor = UIColor.clear
        } else {
            containerView.alpha = 0.7
            containerView.layer.borderWidth = 0
            containerView.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    @IBAction func didPressInfo(_ sender: Any) {
        self.delegate?.didPressInfo(on: self)
    }
    
}
