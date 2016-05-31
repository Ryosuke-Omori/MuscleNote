//
//  AppDelegate.swift
//  MuscleNote
//
//  Created by 大森　亮佑 on 2016/04/07.
//  Copyright © 2016年 RyosukeOmori. All rights reserved.
//

import UIKit


struct UserData {
    var userName: String
    var userWeight: Float
    var userLeps: Int
    
    //static関数(タイプメソッド):インスタンスを生成せずに利用できるメソッド
    static func SetUserData(dic: NSDictionary?) -> UserData {
        let name = dic?["userName"] as? String ?? "None"
        let weight = dic?["userWeight"] as? Float ?? 0.0
        let leps = dic?["userLeps"] as? Int ?? 0
        
        return UserData(userName: name, userWeight: weight, userLeps: leps)
    }
    
    func GetUserData() -> NSDictionary {
        let dic: NSDictionary = [
        "userName": self.userName,
        "userWeight": self.userWeight,
        "userLeps": self.userLeps
        ]
        
        return dic
    }
}



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var myUserDefault: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var userData: [UserData]?
    var userSelected: String?
    

    //アプリが初めて起動した時
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    //アプリを閉じた時に呼ばれる
    func applicationDidEnterBackground(application: UIApplication) {
        if userSelected != nil {
            myUserDefault.setObject(userSelected! as String, forKey: "userSelected")
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    //アプリを開いた時に呼ばれる
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        userSelected = myUserDefault.objectForKey("userSelected") as? String
        print("アプリを開いた時に確定されたuserSelected: \(userSelected)")
    }

    //フリックしてアプリが終了した時
    func applicationWillTerminate(application: UIApplication) {
        if userSelected != nil {
            myUserDefault.setObject(userSelected! as String, forKey: "userSelected")
        }
    }


}

