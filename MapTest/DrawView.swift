//
//  DrawView.swift
//  MapTest
//
//  Created by Maciej Koziel on 30/01/2018.
//  Copyright © 2018 Maciej Koziel. All rights reserved.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift

protocol DrawViewDelegate: class {
    func drawView(view: DrawView, didCompletedDrawing points: [CGPoint])
}

class DrawView: UIView {
    
    weak var delegate: DrawViewDelegate?
    let disposeBag = DisposeBag()
    
    private var points = [CGPoint]()
    private var lastPosition = CGPoint()
    
    private var path = UIBezierPath()
    
    init() {
        super.init(frame: .zero)
        
        setupDrawing()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let strokeColor = UIColor.blue
        strokeColor.setStroke()
        
        path.stroke()
    }

    
    private func setupDrawing() {
        isMultipleTouchEnabled = false
        isOpaque = false
        
        rx.panGesture().when(.began)
            .bind(onNext: start)
            .disposed(by: disposeBag)
        
        rx.panGesture().when(.changed)
            .bind(onNext: move)
            .disposed(by: disposeBag)
        
        rx.panGesture().when(.ended)
            .bind(onNext: end)
            .disposed(by: disposeBag)
    }
    
    private func start(gestureRecognizer: UIPanGestureRecognizer) {
        points = [CGPoint]()
        lastPosition = gestureRecognizer.location(in: gestureRecognizer.view)
        
        path = UIBezierPath()
        path.lineWidth = 2.0
        path.move(to: lastPosition)
        setNeedsDisplay()
    }
    
    private func move(gestureRecognizer: UIPanGestureRecognizer) {
        let location = gestureRecognizer.location(in: gestureRecognizer.view)
        points.append(location)
        
        path.addLine(to: location)
        setNeedsDisplay()
    }
    
    private func end(gestureRecognizer: UIPanGestureRecognizer) {
        delegate?.drawView(view: self, didCompletedDrawing: points)
        
        path = UIBezierPath()
        setNeedsDisplay()
    }
}
