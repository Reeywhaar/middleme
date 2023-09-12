//
//  MiddleMeApp.swift
//  MiddleMe
//
//  Created by Mikhail Vyrtsev on 26.05.2022.
//

import SwiftUI
import ServiceManagement
import Carbon

@main
struct MiddleMeApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    private let settings = Settings()

    private let handler = GlobalEventMonitor()
    private let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    #if DEBUG
    private let isDebug = true
    #else
    private let isDebug = true
    #endif

    init() {
        if isPreview { return }
        
        handler.start()
        handler.register()

        appLogger.info("Registering login item")
        if !isPreview && !isDebug {
            try? SMAppService.mainApp.register()
        }

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
            .onAppear {
                if isPreview { return }
                
                appLogger.info("Making app active")
                NSApplication.shared.activate(ignoringOtherApps: true)
            }
        }.windowResizability(.contentSize)
    }

    private func handleTerminate(notification: Notification) {
        if(appDelegate.activeExit) {
            appLogger.info("Unregistering login item")
            if !isPreview && !isDebug {
                try? SMAppService.mainApp.unregister()
            }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var activeExit = false

    @MainActor
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        let event = NSAppleEventManager.shared().currentAppleEvent
        let reason = event?.attributeDescriptor(forKeyword: UInt32(kEventParamReason))?.typeCodeValue
        activeExit = reason != kAEShutDown && reason != kAERestart && reason != kAEReallyLogOut
        appLogger.info("Application will terminate \(self.activeExit ? "actively" : "passively") with reason \(reason.debugDescription)")
        return .terminateNow
    }
}

enum AgentError: Error {
    case noId
    case noPath
}
