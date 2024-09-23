//
//  GlobalEventMonitor.swift
//  MiddleMe
//
//  Created by Mikhail Vyrtsev on 26.05.2022.
//

import Foundation
import SwiftUI
import Combine

class GlobalEventMonitor {
    private var listener: OpenMTListener?
    
    private var touchesInterval: Int16 = 0
    private var startCoordinates: NSPoint = .zero
    private var lastCoordinates: NSPoint = .zero
    private var maxTouches = 0
    private var cancellables: [AnyCancellable] = []
    private var shouldStart = false

    deinit {
        stop()
    }
    
    public func register() {
        NSWorkspace.shared.notificationCenter.publisher(for: NSWorkspace.willSleepNotification).sink(receiveValue: { [weak self] (_) in
            self?.shouldStart = false
            self?.stop()
        }).store(in: &cancellables)
        
        NSWorkspace.shared.notificationCenter.publisher(for: NSWorkspace.didWakeNotification).sink(receiveValue: { [weak self] (_) in
            self?.shouldStart = true
            // Adding delay to make it work on M1 cpu
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                if self == nil || !self!.shouldStart { return }
                self?.start()
            })
        }).store(in: &cancellables)
    }

    public func start() {
        if listener != nil { return }
        let manager = OpenMTManager.shared()
        listener = manager?.addListener(withTarget: self, selector: #selector(process))
    }
    
    public func stop() {
        if let listener = listener {
            OpenMTManager.shared()?.remove(listener)
        }
        listener = nil
    }
    
    @objc func process(_ count: Int, _ touches: UnsafePointer<MTTouch>) {
        let buffer = UnsafeBufferPointer(start: touches, count: count);
        let touches = Array(buffer)
        let touchesCount = touches.count
        
        let ended = touchesCount == 0
        
        if touchesCount == 3 {
            lastCoordinates = averageCoordinates(coords: touches.map({ NSPoint(x: CGFloat($0.normalizedPosition.position.x), y: CGFloat($0.normalizedPosition.position.y)) }))
            if startCoordinates == .zero { startCoordinates = lastCoordinates }
        }
        
        touchesInterval = min(touchesInterval + 1, 500)
        
        maxTouches = max(maxTouches, touchesCount)
        
        if(ended) {
            let ismiddle = touchesInterval <= 44 && maxTouches == 3
            
            if ismiddle {
                let distance = distance(startCoordinates, lastCoordinates)
                let isSwipe = distance >= 0.005
                
                if !isSwipe {
                    generateMiddleClick()
                }
            }
            
            startCoordinates = .zero
            touchesInterval = 0
            maxTouches = 0
        }
    }
    
    private func generateMiddleClick() {
        guard let screen = getCurrentScreen() else { return }
        
        #if DEBUG
        print("TAP!", screen.localizedName, NSEvent.mouseLocation)
        #else
        let position = cgPoint(from: NSEvent.mouseLocation, forScreen: screen)
        let source = CGEventSource.init(stateID: .hidSystemState)
        let eventDown = CGEvent(mouseEventSource: source, mouseType: .otherMouseDown, mouseCursorPosition: position , mouseButton: .center)
        let eventUp = CGEvent(mouseEventSource: source, mouseType: .otherMouseUp, mouseCursorPosition: position , mouseButton: .center)
        eventDown?.post(tap: .cghidEventTap)
        usleep(100)
        eventUp?.post(tap: .cghidEventTap)
        #endif
    }
    
    private func getCurrentScreen() -> NSScreen? {
        let mouseLocation = NSEvent.mouseLocation
        let screens = NSScreen.screens
        let screenWithMouse = (screens.first { NSMouseInRect(mouseLocation, $0.frame, false) })

        return screenWithMouse
    }
    
    private func computeOffsets(for screen: NSScreen, primaryScreen: NSScreen) -> (CGFloat, CGFloat) {
        var offsetLeft = screen.frame.origin.x
        var offsetTop = primaryScreen.frame.size.height - (screen.frame.origin.y + screen.frame.size.height)

        if screen == primaryScreen {
            offsetTop = 0
            offsetLeft = 0
        }

        return (offsetLeft, offsetTop)
    }
        
    private func cgPoint(from cgpoint: CGPoint, forScreen: NSScreen?) -> CGPoint {
        guard let screen = forScreen,
              let primaryScreen = NSScreen.screens.first
        else {
            return CGPoint(x: cgpoint.x, y: cgpoint.y)
        }

        let (_, offsetTop) = computeOffsets(for: screen, primaryScreen: primaryScreen)
        let menuScreenHeight = screen.frame.maxY
        return CGPoint(x: cgpoint.x, y: menuScreenHeight - cgpoint.y + offsetTop)
    }
    
    private func averageCoordinates(coords: [NSPoint]) -> NSPoint {
        if coords.isEmpty { return .zero }
        let x = coords.map({ $0.x }).reduce(0, +) / CGFloat(coords.count)
        let y = coords.map({ $0.y }).reduce(0, +) / CGFloat(coords.count)
        return NSPoint(x: x, y: y)
    }
    
    private func distance(_ a: NSPoint, _ b: NSPoint) -> CGFloat {
        // √((x_2-x_1)²+(y_2-y_1)²)
        return sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2))
    }
}
