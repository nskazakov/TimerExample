//
//  ViewController.swift
//  TimerExample
//
//  Created by Nikita Kazakov on 15.10.2021.
//

import UIKit

class TimerView: UIViewController {

    // MARK: - Properties

    private let circleLayer = CAShapeLayer()
    private var animation = CABasicAnimation()

    private var timer: Timer?

    private var counter = 0 {
        willSet {
            timeLabel.text = newValue < 10 ? "00:0\(newValue)" : "00:\(newValue)"
            circleProgressView.progressAnimation(duration: TimeInterval(counter))
        }
    }

    private var isWorkTime = true {
        willSet {
            timeLabel.textColor = newValue ? Color.workStateColor : Color.relaxStateColor
            button.tintColor = newValue ? Color.workStateColor : Color.relaxStateColor
            circleLayer.strokeColor = newValue ? Color.workStateColor.cgColor : Color.relaxStateColor.cgColor
            counter = newValue ? Metric.workTimeValue : Metric.relaxTimeValue
        }
    }

    private var isExecuteTimer = false {
        didSet {
            button.isSelected = isExecuteTimer
        }
    }

    // MARK: - Views

    private let timeLabel = UILabel()
    private let button = UIButton(type: .system)
    private lazy var circleProgressView = CircularProgressBarView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()

        setupViews()
    }

    private func setupViews() {
        circleProgressView.progressAnimation(duration: TimeInterval(1))

        counter = Metric.workTimeValue
        isWorkTime = true

        timeLabel.font = .systemFont(ofSize: Metric.fontSize)

        button.setImage(Icon.pauseIcon, for: .selected)
        button.setImage(Icon.startIcon, for: .normal)

        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }

    private func setupHierarchy() {
        view.addSubview(timeLabel)
        view.addSubview(button)
        view.addSubview(circleProgressView)
//        view.layer.addSublayer(circleLayer)
    }

    private func setupLayout() {
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: Metric.buttonTopOffset).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        circleProgressView.translatesAutoresizingMaskIntoConstraints = false
        circleProgressView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        circleProgressView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circleProgressView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        circleProgressView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }

    private func setupAnimationLayer() {
        let circlePath = UIBezierPath(arcCenter: view.center, radius: 126,
                                      startAngle: CGFloat(3 * Double.pi / 2),
                                      endAngle: CGFloat(-Double.pi / 2), clockwise: true)
        circleLayer.path = circlePath.cgPath
        circleLayer.lineWidth = 5
        circleLayer.fillColor =  UIColor.clear.cgColor
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = 0
    }

    // MARK: - Actions

    @objc private func timerAction() {
        guard counter > 0 else {
            isExecuteTimer = !isExecuteTimer
            isWorkTime = !isWorkTime
            timer?.invalidate()
            return
        }
        counter -= 1
    }

    @objc private func buttonAction() {

        if !isExecuteTimer {
            timer = Timer.scheduledTimer(timeInterval: 1,
                target: self, selector: #selector(timerAction),
                userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
        }

        isExecuteTimer = !isExecuteTimer
    }

    private func updateAnimation(with time: Double) {
        animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = time
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        circleLayer.add(animation, forKey: "animation")
    }
}

// MARK: - Constants

extension TimerView {

    enum Metric {
        static let fontSize: CGFloat = 34
        static let buttonTopOffset: CGFloat = 20
        static let workTimeValue: Int = 15
        static let relaxTimeValue: Int = 5
    }

    enum Icon {
        static let pauseIcon = UIImage(systemName: "pause")
        static let startIcon = UIImage(systemName: "play")
    }

    enum Color {
        static let workStateColor = UIColor.systemRed
        static let relaxStateColor = UIColor.systemGreen
    }
}

extension CALayer {
    func pauseAnimation() {
        if isPaused() == false {
            let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
            speed = 0.0
            timeOffset = pausedTime
        }
    }

    func resumeAnimation() {
        if isPaused() {
            let pausedTime = timeOffset
            speed = 1.0
            timeOffset = 0.0
            beginTime = 0.0
            let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
            beginTime = timeSincePause
        }
    }

    func isPaused() -> Bool {
        return speed == 0
    }
}
