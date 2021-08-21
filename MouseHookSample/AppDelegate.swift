//
//  AppDelegate.swift
//  MouseHookSample
//
//  Created by MuronakaHiroaki on 2021/08/19.
//

import Cocoa
import ServiceManagement
import os.log
@main
class AppDelegate: NSObject, NSApplicationDelegate {
    static let launcherAppId = "hmu.MouseHookSampleLauncher"
    @IBOutlet var statusBarMenu: NSMenu!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        NSLog("is trusted. \(AXIsProcessTrusted())")
        StatusBarItem.instance.statusMenu = statusBarMenu
        StatusBarItem.instance.refreshVisibility()
        checkLaunchOnLogin()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

extension AppDelegate {
    private func checkLaunchOnLogin() {
        let running = NSWorkspace.shared.runningApplications
        let isRunning = !running.filter({$0.bundleIdentifier == AppDelegate.launcherAppId}).isEmpty
        if isRunning {
            let killNotification = Notification.Name("killLauncher")
            DistributedNotificationCenter.default().post(name: killNotification, object: Bundle.main.bundleIdentifier!)
        }
//        if !Defaults.SUHasLaunchedBefore {
//            Defaults.launchOnLogin.enabled = true
//        }
        
        // Even if we are already set up to launch on login, setting it again since macOS can be buggy with this type of launch on login.
//        if Defaults.launchOnLogin.enabled {
            let smLoginSuccess = SMLoginItemSetEnabled(AppDelegate.launcherAppId as CFString, true)
            if !smLoginSuccess {
                if #available(OSX 10.12, *) {
                    os_log("Unable to enable launch at login. Attempting one more time.", type: .info)
                }
                SMLoginItemSetEnabled(AppDelegate.launcherAppId as CFString, true)
            }
        //}
    }
}

