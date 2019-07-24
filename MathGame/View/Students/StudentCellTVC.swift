//
//  StudentCellTVC.swift
//  MathGame
//
//  Created by Robert Sandru on 7/24/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit

class StudentCellTVC: UITableViewCell {

    var student: Student?
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var lastActivity: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var deleteButton: RoundedButton!
    
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
        deleteButton.isHidden = mode != .delete
        
        if mode == .delete {
            deleteButton.backgroundColor = UIColor.red
        }
    }
    
    @IBAction func onDelete(_ sender: Any) {
        let cdh = CoreDataHelper()
        guard let student = student else { return }
        cdh.deleteStudent(student: student)
        
        vcViewModel?.refreshStudents()
    }
}
