//
//  KeyboardAwareness.swift
//  Vote Bubble
//
//  Created by Warren Whipple on 7/11/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit
import CoreGraphics

private extension UIViewAnimationCurve {
    var animationOptions: UIViewAnimationOptions {
        return UIViewAnimationOptions(rawValue: UInt(rawValue) << 16)
    }
}

extension MessagesViewController {

    func connectKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(MessagesViewController.keyboardWillShow(notification:)),
            name: .UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(MessagesViewController.keyboardWillHide(notification:)),
            name: .UIKeyboardWillHide,
            object: nil
        )
    }

    func disconnectKeyboardNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: .UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: .UIKeyboardWillHide,
            object: nil
        )
    }

    func keyboardWillShow(notification: NSNotification) {
        print("Keyboard will show.")
        if  let info = notification.userInfo,
            let height = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue().size.height,
            let duration = info[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curveIndex = info[UIKeyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIViewAnimationCurve(rawValue: curveIndex) {
            keyboardHeight = height
            keyboardAnimationDuration = duration
            keyboardAnimationCurve = curve
        }
        if presentationStyle == .expanded {
            adjustForKeyboardShow()
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        print("Keyboard will hide.")
        if  let info = notification.userInfo,
            let duration = info[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curveIndex = info[UIKeyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIViewAnimationCurve(rawValue: curveIndex) {
            keyboardAnimationDuration = duration
            keyboardAnimationCurve = curve
        }
        adjustForKeyboardHide()
    }

    func adjustForKeyboardShow(animate: Bool = true) {
        guard let keyboardHeight = keyboardHeight else { return }
        bottomConstraint.constant = keyboardHeight
        if animate,
            let duration = keyboardAnimationDuration,
            let curve = keyboardAnimationCurve {
            UIView.animate(
                withDuration: duration,
                delay: 0,
                options: [.beginFromCurrentState, curve.animationOptions],
                animations: { self.view.layoutIfNeeded() },
                completion: nil
            )
        } else {
            view.setNeedsLayout()
        }
    }

    func adjustForKeyboardHide(animate: Bool = true) {
        bottomConstraint.constant = 0
        if animate,
            let duration = keyboardAnimationDuration,
            let curve = keyboardAnimationCurve {
            UIView.animate(
                withDuration: duration,
                delay: 0,
                options: [.beginFromCurrentState, curve.animationOptions],
                animations: { self.view.layoutIfNeeded() },
                completion: nil
            )
        } else {
            view.setNeedsLayout()
        }
    }
}
