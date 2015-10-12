//
//  AppDelegate.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 2/12/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        NavigationBar.appearance().barTintColor = UIColor(red: 0.7, green: 0.7, blue: 1, alpha: 1)
        NavigationBar.appearance().tintColor = UIColor.blackColor()
        return true
    }

}

