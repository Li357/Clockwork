//
//  StatusBarController.swift
//  Clockwork
//
//  Created by Andrew Li on 1/4/22.
//

import AppKit
import SwiftUI

class StatusBarController {
    private var dbController: DatabaseController
    private var timesheetWindow: NSWindow?
    
    private var statusBarItem: NSStatusItem
    private var menuStatusBarItem: NSStatusItem
    private var menu: NSMenu
    
    private var timer: Timer?
    private var _isPaused: Bool = true
    var isPaused: Bool {
        get { _isPaused }
        set {
            _isPaused = newValue
            let symbol = _isPaused ? "pause" : "play"
            let description = "\(_isPaused ? "Stop" : "Start") Timer"
            statusBarItem.button?.image = NSImage(systemSymbolName: "\(symbol).fill", accessibilityDescription: description)
        }
    }
    
    private var _currTime: Int = 0
    var currTime: Int {
        get { _currTime }
        set {
            _currTime = newValue
            statusBarItem.button?.title = convertToTimeString(_currTime)
        }
    }
    
    init() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem.behavior = .removalAllowed
    
        statusBarItem.button?.action = #selector(self.toggleTimer)
        statusBarItem.button?.imagePosition = .imageLeft
        
        menu = NSMenu(title: "Clockwork Settings")
        let openTimesheetItem = menu.addItem(withTitle: "Open Timesheet", action: #selector(openTimesheet), keyEquivalent: "")
        let saveCurrentEntryItem = menu.addItem(withTitle: "Save Current Time", action: #selector(addToDatabase), keyEquivalent: "")
        let quitItem = menu.addItem(withTitle: "Quit Clockwork", action: #selector(quitClockwork), keyEquivalent: "q")
        
        menuStatusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        menuStatusBarItem.behavior = .removalAllowed
        menuStatusBarItem.button?.image = NSImage(systemSymbolName: "gearshape.fill", accessibilityDescription: "Clockwork Settings")
        menuStatusBarItem.menu = menu
        
        dbController = try! DatabaseController()
        
        // to trigger setters
        isPaused = _isPaused
        currTime = _currTime
        
        menuStatusBarItem.button?.target = self
        statusBarItem.button?.target = self
        openTimesheetItem.target = self
        saveCurrentEntryItem.target = self
        quitItem.target = self
    }
    
    func cleanUp() throws {
        try addToDatabase()
    }
    
    @objc private func toggleTimer() {
        if isPaused {
            self.isPaused = false
            timer = Timer(timeInterval: 1, repeats: true) { _ in
                self.currTime += 1
            }
            RunLoop.current.add(timer!, forMode: .common)
        } else {
            isPaused = true
            timer!.invalidate()
        }
    }
    
    @objc private func openTimesheet() {
        timesheetWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        timesheetWindow!.title = "Clockwork Timesheet"
        timesheetWindow!.center()
        timesheetWindow!.contentView = NSHostingView(rootView: TimesheetView(entries: dbController.entries))
        timesheetWindow!.orderFrontRegardless()
        timesheetWindow!.isReleasedWhenClosed = false
    }
    
    @objc private func addToDatabase() throws {
        let entry = Entry(date: Date(), duration: currTime)
        try dbController.add(entry: entry)
        currTime = 0
    }
    
    @objc private func quitClockwork() {
        NSApp.terminate(self)
    }
}
