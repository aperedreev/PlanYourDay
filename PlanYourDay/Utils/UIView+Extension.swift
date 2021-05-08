//
//  UIView+Extension.swift
//  PlanYourDay
//
//  Created by NIKOLAI BORISOV on 06.05.2021.
//

import UIKit

extension UIView {
  @IBInspectable var cornerRadius: CGFloat {
    get { return self.layer.cornerRadius }
    set { self.layer.cornerRadius = newValue }
  }
  
  func setUpBorder() {
    self.layer.borderWidth = 2
    self.layer.borderColor = UIColor.white.cgColor
  }
}
