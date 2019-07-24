//
//  StudentCellTVC.swift
//  MathGame
//
//  Created by Robert Sandru on 7/24/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit

class StudentCellTVC: UITableViewCell {

    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var lastActivity: UILabel!
    @IBOutlet weak var container: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customizeContainer()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            container.backgroundColor = Constants.Colors.tableRowStudentSelected
        } else {
            
            container.backgroundColor = Constants.Colors.tableRowStudent
        }
    }
    
    func customizeContainer() {
        
        container.layer.cornerRadius = 15
    }
    
}
