//
//  Storyboard.swift
//  MathGame
//
//  Created by Robert Sandru on 7/22/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit

enum ViewControllerIdentifiers: String {
    
    case studentsVC = "StudentsVC"
    case studentsNVC = "StudentsNVC"
    case studentDetailVC = "StudentDetailVC"
    case initialVC = "InitialVC"
    
    case gamesVC = "GamesVC"
    case numbersBondVC = "NumbersBondVC"
    
    case settingsVC = "SettingsVC"
}

class Storyboard {
    
    static var shared: Storyboard = Storyboard()
    
    private init() { }
    
    func getViewController<T: UIViewController>(by viewControllerIdentifiers: ViewControllerIdentifiers) -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifiers.rawValue)
        return vc as! T
    }
}
