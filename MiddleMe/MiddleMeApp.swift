//
//  MiddleMeApp.swift
//  MiddleMe
//
//  Created by Mikhail Vyrtsev on 26.05.2022.
//

import SwiftUI
import LaunchAtLogin

@main
struct MiddleMeApp: App {
    private let settings = Settings()
    
    private let handler = GlobalEventMonitor()
    
    init() {
        handler.start()
        handler.register()

        LaunchAtLogin.isEnabled = true
        
        NotificationCenter.default.addObserver(forName: NSApplication.willTerminateNotification, object: nil, queue: .main, using: self.handleTerminate)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear{
                settings.checkAccess()
            }
            .environmentObject(settings)
            .fixedSize()
            .preferredColorScheme(.dark)
            .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { (_) in
                settings.checkAccess()
            }
        }
    }
    
    private func handleTerminate(notification: Notification) {
        LaunchAtLogin.isEnabled = false
    }
}

enum AgentError: Error {
    case noId
    case noPath
}
