//
//  StudentCellTVC.swift
//  MathGame
//
//  Created by Robert Sandru on 7/24/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit

protocol StudentCellTVCDelegate: class {
    func didPressInfo(on cell: StudentCellTVC, with student: Student)
}

class StudentCellTVC: UITableViewCell {
    
    var student: Student?
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var lastActivity: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var extraButton: RoundedButton!
    @IBOutlet weak var extraButtonTwo: RoundedButton!
    
    weak var delegate: StudentCellTVCDelegate?
    var vcViewModel: StudentsVM?
    
    var mode: StudentsMode = .normal
    
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
        extraButton.isHidden = mode == .normal
        extraButtonTwo.isHidden = mode != .reset
        if mode == .delete {
            extraButton.backgroundColor = UIColor.red
            extraButton.setTitle("-", for: .normal)
        } else if mode == .reset {
            extraButton.backgroundColor = Constants.Colors.tableRowStudentSelected
            extraButton.setTitle("🔄", for: .normal)
            extraButtonTwo.backgroundColor = Constants.Colors.tableRowStudentSelected
            extraButtonTwo.setTitle("ℹ️", for: .normal)
        }
    }
    
    @IBAction func onExtraButton(_ sender: Any) {
        if mode == .delete {
            let cdh = CoreDataHelper()
            guard let student = student else { return }
            cdh.deleteStudent(student: student)
        }
        if mode == .reset {
            
        }
        vcViewModel?.refreshStudents()
    }
    
    @IBAction func onExtraButtonTwo(_ sender: Any) {
        if mode == .reset {
            guard let student = student else { return }
            delegate?.didPressInfo(on: self, with: student)
        }
    }
}
