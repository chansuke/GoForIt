//
//  AppDelegate.swift
//  GoForIt
//
//  Created by Lidner on 14/9/20.
//  Copyright (c) 2014 Solfanto. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let tabBarController = UITabBarController()
        let alarmViewController = AlarmViewController(style: .Plain)
        let recorderViewController = RecorderViewController()
        let playViewController = PlayViewController()
        
        let tabController1 = UINavigationController(rootViewController: recorderViewController)
        tabController1.tabBarItem = UITabBarItem(title: "Recorder", image: UIImage(named: "tabbar_microphone"), tag: 1)
        
        let tabController2 = UINavigationController(rootViewController: playViewController)
        tabController2.tabBarItem = UITabBarItem(title: "Cheer me up!", image: UIImage(named: "tabbar_play"), tag: 2)
        
        let tabController3 = UINavigationController(rootViewController: alarmViewController)
        tabController3.tabBarItem = UITabBarItem(title: "Alarm", image: UIImage(named: "tabbar_alarm"), tag: 3)
        
        tabBarController.viewControllers = [tabController1, tabController2, tabController3]
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

