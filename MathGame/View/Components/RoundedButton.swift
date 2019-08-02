//
//  RoundedButton
//  MathGame
//
//  Created by Robert Sandru on 7/24/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customize()
    }
    
    func customize() {
        layer.cornerRadius = frame.width / 2
////        backgroundColor = Constants.Colors.createStudent
//        setTitleColor(Constants.Colors.createStudentLabel, for: .normal)
//        setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
    }
}
