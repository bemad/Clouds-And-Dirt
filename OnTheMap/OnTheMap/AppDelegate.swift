//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Bhavya Madan on 05/02/18.
//  Copyright © 2018 Bhavya Madan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var userID: String = ""
    //firstname last name app delegate
    var fNAD: String = ""
    var lNAD: String = ""
    var objectId: String = ""
    var uniqueKey: String = ""
    var willOverwrite: Bool = false
    let errorMessage = ErrorMessage()
    
    struct ErrorMessage {
        let DataError = "Error Getting Data!"
        let MapError = "Failed To Geocode!"
        let UpdateError = "Failed To Update Location!"
        let InvalidLink = "Invalid Link!"
        let MissingLink = "Need To Enter Link!"
        let CantLogin = "Network Connection Is Offline!"
        let InvalidEmail = "Invalid Email Or Password!"
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

