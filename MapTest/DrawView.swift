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
        lastPosition = gestureRecognizer.location(in: gestureRecognizer.view)
        points = [lastPosition]
        
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
        guard points.count > 2 else {
            return
        }
        
        var startIndex = 0
        var endIndex = 1
        var newPoints = [points[startIndex]]
        while endIndex < points.count - 1 {
            let dist = distance(lineStart: points[startIndex], lineEnd: points[endIndex], point: points[endIndex + 1])
            print(dist)
            
            if dist > 0.5 {
                newPoints.append(points[endIndex])
                startIndex = endIndex
            }
            
            endIndex += 1
        }
        newPoints.append(points.last!)
        delegate?.drawView(view: self, didCompletedDrawing: newPoints)
        
        path = UIBezierPath()
        setNeedsDisplay()
    }
    
    // Distance between line and point: https://en.wikipedia.org/wiki/Distance_from_a_point_to_a_line
    private func distance(lineStart: CGPoint, lineEnd: CGPoint, point: CGPoint) -> Double {
        let x0 = point.x, y0 = point.y
        let x1 = lineStart.x, y1 = lineStart.y
        let x2 = lineEnd.x, y2 = lineEnd.y
        
        let numerator =  abs((y2 - y1) * x0 - (x2 - x1) * y0 + x2 * y1 - y2 * x1)
        let denominator = sqrt(pow(y2 - y1, 2) + pow(x2 - x1, 2))
        
        return denominator == 0.0 ? 0.0 : Double(numerator / denominator)
    }
}
