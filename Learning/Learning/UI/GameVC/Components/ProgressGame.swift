//
//  ProgressGame.swift
//  Learning
//
//  Created by Javi Castillo Risco on 11/01/2021.
//

import UIKit

class ProgressGame: UIView {

    var progress: UIView!
    var widthProgressConstraint: NSLayoutConstraint!
    var maximumValue = 0
    var successNumber = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareView()
    }

    private func prepareView() {
        layer.cornerRadius = 10

        backgroundColor = .blue
        translatesAutoresizingMaskIntoConstraints = false

        progress = UIView()
        progress.layer.cornerRadius = 10
        progress.backgroundColor = .red
        progress.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progress)

        widthProgressConstraint = NSLayoutConstraint(item: progress!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        progress.addConstraint(widthProgressConstraint)
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[progress]", options: .alignAllTop, metrics: nil, views: ["progress": progress!])
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[progress]-0-|", options: .alignAllLeft, metrics: nil, views: ["progress": progress!])
        addConstraints(horizontalConstraints+verticalConstraints)
    }

    func setMaximum(_ maximum: Int) {
        maximumValue = maximum
    }

    func addSuccess() {
        successNumber += 1
        if successNumber > maximumValue {
            successNumber = maximumValue
        }
        let sizeOneSuccess = frame.size.width / CGFloat(maximumValue)
        let newSizeSuccess = sizeOneSuccess * CGFloat(successNumber)
        layoutIfNeeded()
        widthProgressConstraint.constant = newSizeSuccess
        UIView.animate(withDuration: 1) {
            self.layoutIfNeeded()
        }
    }

}
