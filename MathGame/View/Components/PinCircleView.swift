//
//  PinCircleView.swift
//  MathGame
//
//  Created by Robert Sandru on 7/22/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit
import RxSwift

enum PinCircleState {
    case normal, error, success
    
    func getColor() -> UIColor {
        switch self {
        case .normal: return .white
        case .error: return .red
        case .success: return .green
        }
    }
}

class PinCircleView: UIView {
    
    var fill: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var state: BehaviorSubject<PinCircleState> = BehaviorSubject(value: .normal)
    var disposeBag: DisposeBag = DisposeBag()
    
    private var circleSize: CGSize = CGSize(width: 15, height: 15)
    private var circleBorder: CGFloat = 1.6
    private var circle: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customize()
    }
    
    override func layoutSubviews() {
        if circle !== nil {
            circle?.frame = getCircleFrame()
        }
    }
    
    func customize() {
        circle = UIView(frame: getCircleFrame())
        circle?.layer.borderWidth = circleBorder
        circle?.layer.borderColor = UIColor.white.cgColor
        circle?.layer.cornerRadius = circleSize.width / 2
        addSubview(circle!)
        rxStart()
    }
    
    func getCircleFrame() -> CGRect {
        return CGRect(x: (bounds.size.width / 2) - (circleSize.width / 2),
                      y: (bounds.size.height / 2) - (circleSize.height / 2),
                      width: circleSize.width,
                      height: circleSize.height)
    }
    
    private func fillCircle() {
        circle?.backgroundColor = UIColor.white
    }
    
    private func unfillCircle() {
        circle?.backgroundColor = UIColor.clear
    }
    
    private func updateView(to state: PinCircleState) {
        colorize(to: state.getColor())
    }
    
    func colorize(to color: UIColor) {
        circle?.backgroundColor = color
        circle?.layer.borderColor = color.cgColor
        
    }
}

extension PinCircleView {
    
    func rxStart() {
        fill.subscribe(onNext: { [weak self] shouldFill in
            shouldFill ? self?.fillCircle() : self?.unfillCircle()
        }).disposed(by: disposeBag)
        
        state.subscribe(onNext: { [weak self] state in
            self?.updateView(to: state)
        }).disposed(by: disposeBag)
    }
}
