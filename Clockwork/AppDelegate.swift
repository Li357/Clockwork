//
//  AppDelegate.swift
//  Clockwork
//
//  Created by Andrew Li on 1/3/22.
//

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusBarItem: NSStatusItem?
    private var menuStatusBarItem: NSStatusItem?
    private var menu: NSMenu?
    
    private var timer: Timer?
    private var _isPaused: Bool?
    private var isPaused: Bool? {
        get { _isPaused }
        set {
            _isPaused = newValue
            statusBarItem?.button?.image = NSImage(systemSymbolName: _isPaused! ? "pause.fill" : "play.fill" , accessibilityDescription: "\(_isPaused! ? "Stop" : "Start") Timer")
        }
    }
    private var _currTime: Int?
    private var currTime: Int? {
        get { _currTime }
        set {
            _currTime = newValue
            statusBarItem?.button?.title = convertToTimeString(currTime!)
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem?.behavior = .removalAllowed
    
        isPaused = true
        currTime = 0
        statusBarItem?.button?.target = self
        statusBarItem?.button?.action = #selector(self.toggleTimer)
        statusBarItem?.button?.imagePosition = .imageLeft
        
        menu = NSMenu(title: "Clockwork Settings")
        menu?.addItem(withTitle: "Check Timesheet", action: #selector(openTimesheet), keyEquivalent: "check-logs")
        
        menuStatusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        menuStatusBarItem?.behavior = .removalAllowed
        menuStatusBarItem?.button?.target = self
        menuStatusBarItem?.button?.image = NSImage(systemSymbolName: "gearshape.fill", accessibilityDescription: "Clockwork Settings")
        menuStatusBarItem?.menu = menu
        
        let notificationCenter = NSWorkspace.shared.notificationCenter
        notificationCenter.addObserver(self, selector: #selector(addToDatabase), name: NSWorkspace.didWakeNotification, object: nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    @objc func toggleTimer() {
        if isPaused! {
            self.isPaused = false
            timer = Timer(timeInterval: 1, repeats: true) { _ in
                self.currTime! += 1
            }
            RunLoop.current.add(timer!, forMode: .common)
        } else {
            isPaused = true
            timer?.invalidate()
        }
    }
    
    @objc func openTimesheet() {
        // TODO
    }
    
    @objc func addToDatabase() {
        // TODO
    }
    
    private func zeroPad(_ seconds: Int) -> String {
        return String(format: "%02d", seconds)
    }
    
    private func convertToTimeString(_ seconds: Int) -> String {
        if seconds < 60 {
            return "00:\(zeroPad(seconds))"
        }
        
        let reducedSeconds = seconds % 60
        let minutes = (seconds - reducedSeconds) / 60
        if minutes < 60 {
            return "\(minutes):\(zeroPad(reducedSeconds))"
        }
        
        let reducedMinutes = minutes % 60
        let hours = (minutes - reducedMinutes) / 60
        return "\(hours):\(zeroPad(reducedMinutes)):\(zeroPad(reducedSeconds))"
    }
}

