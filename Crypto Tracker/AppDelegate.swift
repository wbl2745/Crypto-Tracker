//
//  AppDelegate.swift
//  Crypto Tracker
//
//  Created by William Lund on 5/20/18.
//  Copyright © 2018 Bill Lund. All rights reserved.
//

import UIKit       // frameworks for iOS and tvOS apps

/**
 This app is based on "Intermediate iOS 11 - Complex and Advanced iPhone Apps" by Nick Walter presented in
 Udemy: (https://www.udemy.com/intermediate-ios-11-complex-and-advanced-iphone-apps/learn/v4/overview).
 The Crypto Price Tracker is found in section 2 of the course.
 
 The app retrieves the current prices of selected cryptocurrencies and allows the user to see the history.
 
 Learning features of this app:
 * Storyboardless -- We're not going to use storyboards, so setting up the windows and view controllers has to be
 done manually.
 * Delegates -- Learned about delegates, specifically that it is a concept of programming by which functions of a
 class can be handed off to another class.
 * Singletons -- A singleton is a pattern that restricts the instantiation of a class to one object, which is useful
 when you need to coordinate actions across the entire app.
 
 Stuff to do
 ===========
 TODO: Instead of coins with 0.0 value getting "loading", check to see if the prices have been loaded and return "loading" if not.
 TODO: Update the prices periodically
 TODO: Redo this with a storyboard
 TODO: Retrieve currencies based on checkboxes (round radio buttons that act like checkboxes)
 
 Declaration
    @UIApplicationMain -- attribute, Creates the entry point and run loop for processing events.
    UIResponder -- class, Instances of UIResponder constitute the event-handling backbone of a UIKit app
    UIApplicationDelegate -- protocol, A set of methods that are called by the singleton UIApplication object in
        response to important events
 */
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    // The backdrop for your app’s user interface and the object that dispatches events to your views.
    var window: UIWindow?

    /**
     Without a storyboard, we need to provide code here to set up the windows.
     
    *****  This is where execution starts. The window needs to be instantiated.
    * 1 *  Whereas a Mac could support multiple windows, the iPhone (and iPad?) only support
    *****  one, but you still need to make the window.
     
    */
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Instantiate the window to be the size of the screen.
        // TODO: I wonder what would happen if it were smaller or larger than the screen?
        window = UIWindow(frame: UIScreen.main.bounds)

        // Instantiate a View Controller which is defined to be CryptoTableViewController
        let cryptoTableVC = CryptoTableViewController()

        // The table is inside a navigation controller.
        let navController = UINavigationController(rootViewController: cryptoTableVC)
        window?.rootViewController = navController

        // Identify the window as being the starting place
        window?.makeKeyAndVisible()
        
        return true
    } // func application

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

