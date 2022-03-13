//
//  AppDelegate.swift
//  Find
//
//

import Cocoa
import SwiftUI


var window: NSWindow!
var tog = true
@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let userD = UserDefaults(suiteName: "com.lightning.Find")
    var contentView:ContentView?
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        if userD?.array(forKey: "typeArray") == nil {
            userD!.set([".txt",".py"],forKey: "typeArray")
        }
        // Create the SwiftUI view that provides the window contents.
            self.contentView = ContentView()
//        userD!.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        
        // Create the window and set the content view.
        window = NSWindow(
              contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
              styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
              backing: .buffered, defer: false)
          window.isReleasedWhenClosed = false
          window.center()
          window.setFrameAutosaveName("Main Window")
          window.contentView = NSHostingView(rootView: self.contentView)
          window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

