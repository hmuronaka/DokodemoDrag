//
//  AppDelegate.swift
//  DokodemoDragLauncher
//
//  Created by MuronakaHiroaki on 2021/08/20.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let mainAppIdentifier = "hmu.DokodemoDrag"
        let running = NSWorkspace.shared.runningApplications
        let isRunning = !running.filter({$0.bundleIdentifier == mainAppIdentifier}).isEmpty
        
        if isRunning {
            self.terminate()
        } else {
            let killNotification = Notification.Name("killLauncher")
            DistributedNotificationCenter.default().addObserver(self,
                                                                selector: #selector(self.terminate),
                                                                name: killNotification,
                                                                object: mainAppIdentifier)
            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.append("MacOS")
            components.append("DokodemoDrag")
            let newPath = NSString.path(withComponents: components)
            NSWorkspace.shared.launchApplication(newPath)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func terminate() {
        NSApp.terminate(nil)
    }
}

