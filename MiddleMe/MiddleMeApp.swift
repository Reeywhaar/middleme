//
//  MiddleMeApp.swift
//  MiddleMe
//
//  Created by Mikhail Vyrtsev on 26.05.2022.
//

import SwiftUI
import LaunchAgent

@main
struct MiddleMeApp: App {
    private let settings = Settings()
    
    private let handler = Box<GlobalEventMonitor?>(nil)
    
    init() {
        handler.value = GlobalEventMonitor()
        handler.value?.start()
        handler.value?.register()

        do {
            let agent = try getAgent()
            try LaunchControl.shared.write(agent)
            LaunchControl.shared.enable(agent)
        } catch {
            print("Unexpected error:", error)
        }
        
        NotificationCenter.default.addObserver(forName: NSApplication.willTerminateNotification, object: nil, queue: .main, using: self.handleTerminate)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(settings)
            .fixedSize()
            .preferredColorScheme(.dark)
            .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { (_) in
                settings.checkAccess()
            }
        }
    }
    
    private func handleTerminate(notification: Notification) {
        let agent = try? getAgent()
        
        if let agent = agent {
            LaunchControl.shared.disable(agent)
            LaunchControl.shared.remove(agent)
        }
        
        do {
            if let url = agent?.url {
                try FileManager.default.removeItem(at: url)
            }
        } catch {
            print("Unexpected error:", error)
        }
    }
    
    private func getAgent() throws -> LaunchAgent {
        guard let bundleId = Bundle.main.bundleIdentifier else { throw AgentError.noId }
        guard let path = Bundle.main.executablePath else { throw AgentError.noPath }
        let agent = LaunchAgent(label: bundleId, program: path )
        agent.runAtLoad = true
        agent.processType = .interactive
        
        agent.url = getAgentsDirectory().appendingPathComponent("\(agent.label).plist")
        return agent
    }
    
    private func getAgentsDirectory() -> URL {
        var url = try! FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        url.appendPathComponent("LaunchAgents")
        return url
    }
}

enum AgentError: Error {
    case noId
    case noPath
}
