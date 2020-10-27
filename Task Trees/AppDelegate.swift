//
//  AppDelegate.swift
//  Task Trees
//
//  Created by Samuel Donovan on 10/15/20.
//

import Cocoa
import SwiftUI
import Combine

var mainWindow: NSWindow!
func toView<T: View>(view: T) {
    mainWindow.contentView = NSHostingView(rootView: view.frame(maxWidth: .infinity, maxHeight: .infinity))
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // establish DateCalculator
        dateCalculator = DateCalculator()
        
        // create View
        let view = MainView(adHocStore: adHocStore)
        
        // create Window
        window = NSWindow(
            contentRect: NSScreen.main!.visibleFrame,
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Main Window")
        mainWindow = window
        toView(view: view)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        print("TERMINATING")
        adHocStore.save()
        recurringTaskManager.save()
    }
}

