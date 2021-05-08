//
//  AppDelegate.swift
//  PlanYourDay
//
//  Created by NIKOLAI BORISOV on 06.05.2021.
//

import UIKit

import UIKit
@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
  var window : UIWindow?
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions
                    launchOptions: [UIApplication.LaunchOptionsKey : Any]?)
  -> Bool {
    if #available(iOS 13, *) {
      
    } else {
      self.window = UIWindow()
      let vc = PlannerViewController()
      self.window!.rootViewController = vc
      self.window!.makeKeyAndVisible()
      self.window!.backgroundColor = .red
    }
    return true
  }
}

