//
//  CircleProgressView.swift
//  TimerExample
//
//  Created by Nikita Kazakov on 15.10.2021.
//

import UIKit

class CircularProgressBarView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()

    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)

    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 80, startAngle: endPoint, endAngle: startPoint, clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 20.0
        circleLayer.strokeEnd = 0.0
        circleLayer.strokeColor = UIColor.white.cgColor
        layer.addSublayer(circleLayer)
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 10.0
        progressLayer.strokeEnd = 1
        progressLayer.strokeColor = UIColor.green.cgColor
        layer.addSublayer(progressLayer)
    }

    func progressAnimation(duration: TimeInterval) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 0.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}
