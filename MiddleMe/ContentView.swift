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
        let width: CGFloat = 240
        
        VStack(spacing: 10) {
            if !settings.permissionGranted {
                VStack(spacing: 20) {
                    HStack(alignment: .center, spacing: 10) {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 14, height: 14)
                        Text(ACCESS_NOT_GRANTED)
                    }
                    
                    Button(OPEN_PREFERENCES, action: {
                        settings.requireAccess()
                    })
                }.frame(width: width).padding(.bottom, 20)
            } else {
                Text(CLOSED_TEXT).fontWeight(.bold).padding(.bottom, 30).frame(width: width, alignment: .leading)
            }
            
            Text(DESCRIPTION_TEXT).frame(width: width, alignment: .leading)
        }.padding(20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(makeSettings(false))
        ContentView().environmentObject(makeSettings(true))
    }
    
    static func makeSettings(_ granted: Bool) -> Settings {
        let settings = Settings()
        settings.permissionGranted = granted
        return settings
    }
}

private let ACCESS_NOT_GRANTED = NSLocalizedString("ContentView.ACCESS_NOT_GRANTED", value: "Accessibility access forbidden", comment: "")
private let OPEN_PREFERENCES = NSLocalizedString("ContentView.OPEN_PREFERENCES", value: "Open preferences", comment: "")
private let CLOSED_TEXT = NSLocalizedString("ContentView.CLOSED_TEXT", value: "This window can be closed.", comment: "")
private let DESCRIPTION_TEXT = NSLocalizedString("ContentView.DESCRIPTION_TEXT", value: """
To quit app press cmd+Q

App auto restarts on reboot if it wasn't explicitly quit.

To reopen this window, just click app icon again.
""", comment: "")
