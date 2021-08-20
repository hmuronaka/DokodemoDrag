//
//  AppDelegate.swift
//  MouseHookSample
//
//  Created by MuronakaHiroaki on 2021/08/19.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet var statusBarMenu: NSMenu!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        NSLog("is trusted. \(AXIsProcessTrusted())")
        StatusBarItem.instance.statusMenu = statusBarMenu
        StatusBarItem.instance.refreshVisibility()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

