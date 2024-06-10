//
//  ExtView.swift
//  Darshan
//
//  Created by Darshan on 10/06/24.
//

import UIKit

extension UIView {
    var topVC: UIViewController? {
        var topResponder: UIResponder? = self.next
        while topResponder != nil {
            if let viewController = topResponder as? UIViewController {
                return viewController
            }
            topResponder = topResponder!.next
        }
        return nil
    }
}
