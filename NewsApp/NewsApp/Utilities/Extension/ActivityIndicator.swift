//
//  ActivityIndicator.swift
//  NewsApp
//
//  Created by Ritesh Raj Singh Deopa on 06/02/21.
//


import UIKit

extension UIView {

    func showDefaultActivityIndicator(shouldDisableUserInteraction: Bool = false) {

        self.removeAnyOldActivityIndicators()
        let activityIndicator = UIActivityIndicatorView(style: .gray)

        activityIndicator.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        activityIndicator.color = UIColor.gray
        self.addSubview(activityIndicator)
        self.bringSubviewToFront(activityIndicator)
        self.isUserInteractionEnabled = !shouldDisableUserInteraction
        activityIndicator.startAnimating()
    }

    func hideDefaultActivityIndicator() {

        for subview in self.subviews {
            if let indicator = subview as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
        self.isUserInteractionEnabled = true
    }

    fileprivate func removeAnyOldActivityIndicators() {
        for subview in self.subviews {
            if let indicator = subview as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
