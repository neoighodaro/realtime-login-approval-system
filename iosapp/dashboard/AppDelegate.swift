//
//  AppDelegate.swift
//  dashboard
//
//  Created by Neo Ighodaro on 06/04/2019.
//  Copyright © 2019 TapSharp. All rights reserved.
//

import UIKit
import PushNotifications
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let pushNotifications = PushNotifications.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        pushNotifications.start(instanceId: AppConstants.PUSHER_BEAMS_INSTANCE_ID)
        pushNotifications.registerForRemoteNotifications()
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        let deny    = UNNotificationAction(identifier: "deny", title: "Deny", options: [.destructive])
        let approve = UNNotificationAction(identifier: "approve", title: "Approve", options: [.foreground, .authenticationRequired])
        
        center.setNotificationCategories([
            UNNotificationCategory(identifier: "LoginActions", actions: [approve, deny], intentIdentifiers: [])
        ])
        
        return true
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        pushNotifications.registerDeviceToken(deviceToken) {
            try? self.pushNotifications.addDeviceInterest(interest: "auth-janedoe-at-pushercom")
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        pushNotifications.handleNotification(userInfo: userInfo)
        completionHandler(.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let name = Notification.Name("status")
        let status = (response.actionIdentifier == "approve") ? "approved" : "denied"
        let userInfo = response.notification.request.content.userInfo
        
        if let aps = userInfo["aps"] as? [String: AnyObject], let payload = aps["payload"] as? [String: String] {
            if status == "approved" {
                NotificationCenter.default.post(name: name, object: nil, userInfo: ["status": status, "payload": payload])
            }
        }
        
        completionHandler()
    }
}

