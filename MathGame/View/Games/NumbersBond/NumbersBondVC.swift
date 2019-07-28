//
//  NumbersBondVC.swift
//  MathGame
//
//  Created by Robert Sandru on 7/28/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit

class NumbersBondVC: UIViewController {

    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var studentName: UILabel!
    
    var viewModel: NumbersBondVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func reloadViews() {
        guard let vm = viewModel else { return }
        gameName.text = vm.game.getName()
        
        let firstName = viewModel?.student.firstName ?? ""
        let lastName = viewModel?.student.lastName ?? ""
        let fullName = firstName + " " + lastName
        studentName.text = fullName
    }

}
