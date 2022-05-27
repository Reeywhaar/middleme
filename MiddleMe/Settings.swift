//
//  Settings.swift
//  MiddleMe
//
//  Created by Mikhail Vyrtsev on 26.05.2022.
//

import Foundation
import SwiftUI

class Settings: ObservableObject {
    @Published var permissionGranted = false
    
    public func checkAccess(){
        //get the value for accesibility
        let checkOptPrompt = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String
        //set the options: false means it wont ask
        //true means it will popup and ask
        let options = [checkOptPrompt: true]
        //translate into boolean value
        
        permissionGranted = AXIsProcessTrustedWithOptions(options as CFDictionary?)
    }
}
