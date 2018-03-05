//
//  AppDelegate.swift
//  04_Eateries
//
//  Created by Admin on 14.01.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // задаем общие правила (апириэнс - внешность) для всех навигейшнконтроллеров
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.721867955, green: 0.7081359182, blue: 0.9016706576, alpha: 1) // цвет фона навигатора
        UINavigationBar.appearance().tintColor = .white // цвет текста меню назад
        
        // меняем цвет фона статусбара
//        let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20))
//        statusBarView.backgroundColor = #colorLiteral(red: 0.721867955, green: 0.7081359182, blue: 0.9016706576, alpha: 1)
//        self.window?.rootViewController?.view.insertSubview(statusBarView, at: 1)
        
        // стили таббара(снизу)
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().barTintColor = #colorLiteral(red: 0.9396317485, green: 0.9358695466, blue: 0.9888927633, alpha: 1)
        UITabBar.appearance().selectionIndicatorImage = UIImage(named: "tabSelectBG") // фоновая картинка выделенного пункта меню
        
        
        // чтоб тайтл не налазил на название предыдущего меню сверху
        // задаем цвет фона и шрифта навбара
        if let barFont = UIFont(name: "AppleSDGothicNeo-Light", size: 24){
//            (будет работать только в X-Code 9)
//            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.foregroundColor: UIColor.white, NSAttributedString.font: barFont]
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName: barFont]
        }
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
        self.coreDataStack.saveContext()
    }


}

