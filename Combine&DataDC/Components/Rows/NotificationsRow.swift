//
//  NotificationRow.swift
//  Combine&DataDC
//
//  Created by Mitch Andrade on 4/2/22.
//

import SwiftUI

struct NotificationRow: View {
    @StateObject var notificationVM = NotificationViewModel()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        Group {
            if notificationVM.permission == .authorized {
                Toggle(isOn: $notificationVM.subscribedToAllNotifications, label: {
                    HStack(spacing: 12) {
                        GradientIcon(icon: "bell.fill")
                        
                        VStack(alignment: .leading) {
                            Text("Notify me of new content")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Text("Max once a week.")
                                .font(.caption2)
                                .opacity(0.2)
                        }
                    }
                })
                .toggleStyle(SwitchToggleStyle(tint: .blue))
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Notifications are disbaled")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    Text("We can't notify you when new content is available.")
                        .font(.caption2)
                        .opacity(0.7)
                    
                    Link(destination: URL(string: UIApplication.openSettingsURLString)!, label: {
                        Text("Open Settings")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    })
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
         
        }
        .onAppear {
            notificationVM.getNotificationSettings()
        }
        .onChange(of: scenePhase, perform: { newPhase in
            if newPhase == .active {
                notificationVM.getNotificationSettings()
            }
        })
    }
}

//struct NotificationRow_Previews: PreviewProvider {
//    static var previews: some View {
//        NotificationRow()
//    }
//}
