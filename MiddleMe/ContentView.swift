//
//  ContentView.swift
//  MiddleMe
//
//  Created by Mikhail Vyrtsev on 26.05.2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        VStack(spacing: 10) {
            if !settings.permissionGranted {
                Group {
                    HStack(alignment: .center, spacing: 10) {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 14, height: 14)
                        Text(ACCESS_NOT_GRANTED)
                    }.padding()
                    
                    Button(OPEN_PREFERENCES, action: {
                        NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)
                    })
                    
                    Spacer().frame(height: 20)
                }
            }
            
            Text(CLOSED_TEXT).frame(width: 240)
        }.padding(20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

private let ACCESS_NOT_GRANTED = NSLocalizedString("ContentView.ACCESS_NOT_GRANTED", value: "Accessibility access forbidden", comment: "")
private let OPEN_PREFERENCES = NSLocalizedString("ContentView.OPEN_PREFERENCES", value: "Open preferences", comment: "")
private let CLOSED_TEXT = NSLocalizedString("ContentView.CLOSED_TEXT", value: """
This window can be closed.

To quit app press cmd+Q

App auto restarts on reboot if it wasn't explicitly quit.

To reopen this window, just click app icon again.
""", comment: "")
