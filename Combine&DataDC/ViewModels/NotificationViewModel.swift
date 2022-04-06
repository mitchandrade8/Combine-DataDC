//
//  NotificationViewModel.swift
//  Combine&DataDC
//
//  Created by Mitch Andrade on 4/5/22.
//

import SwiftUI
import UserNotifications
import FirebaseMessaging

class NotificationViewModel: ObservableObject {
    @Published var permission: UNAuthorizationStatus?
    @AppStorage("subscribedToAllNotifications") var subscribedToAllNotifications: Bool = false {
        didSet {
            if subscribedToAllNotifications {
                subscribeToAllTopics()
            } else {
                unsubscribeFromAllTopics()
            }
        }
    }
    
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings() { permission in
            DispatchQueue.main.async {
                self.permission = permission.authorizationStatus
            }
            
            if permission.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                
                if self.subscribedToAllNotifications {
                    self.subscribeToAllTopics()
                } else {
                    self.unsubscribeFromAllTopics()
                }
                
            } else {
                DispatchQueue.main.async {
                    UIApplication.shared.unregisterForRemoteNotifications()
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                }
                self.unsubscribeFromAllTopics()
            }
        }
    }
    
    private func subscribeToAllTopics() {
        guard permission == .authorized else { return }
        
        Messaging.messaging().subscribe(toTopic: "all") { error in
            if let error = error {
                print("Error while subscribing: ", error)
                return
            }
            print("Subscribed to notifications for all topics")
        }
    }
    
    private func unsubscribeFromAllTopics() {
        Messaging.messaging().unsubscribe(fromTopic: "all") { error in
            if let error = error {
                print("Error while unsubscribing: ", error)
                return
            }
            print("Unsubscribed from notifications for all topics")
        }
    }
}
