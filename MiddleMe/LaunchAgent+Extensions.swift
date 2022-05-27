//
//  LaunchControl+Extensions.swift
//  MiddleMe
//
//  Created by Mikhail Vyrtsev on 28.05.2022.
//

import Foundation
import LaunchAgent
import SystemConfiguration

extension LaunchControl {
    static let launchctl = "/bin/launchctl"
    
    
    func enable(_ agent: LaunchAgent) {
        let arguments = ["enable", "gui/\(getuid())/\(agent.label)"]
        Process.launchedProcess(launchPath: LaunchControl.launchctl, arguments: arguments)
    }
    
    func disable(_ agent: LaunchAgent) {
        let arguments = ["disable", "gui/\(getuid())/\(agent.label)"]
        Process.launchedProcess(launchPath: LaunchControl.launchctl, arguments: arguments)
    }
    
    func remove(_ agent: LaunchAgent) {
        let arguments = ["remove", agent.label]
        Process.launchedProcess(launchPath: LaunchControl.launchctl, arguments: arguments)
    }
}
