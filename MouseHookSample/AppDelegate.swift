//
//  AppDelegate.swift
//  MouseHookSample
//
//  Created by MuronakaHiroaki on 2021/08/19.
//

import Cocoa
import ServiceManagement
import os.log
import Defaults

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
        
        MouseHookService.shared.start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

extension AppDelegate {
    @IBAction func toggleIsLaunchOnLogin(_ item: NSMenuItem) {
        let newSetting = SettingService.shared.toggleLaunchOnLogin()
        item.state = newSetting ? .on : .off
    }
    
    @IBAction func toggleIsEnable(_ item: NSMenuItem) {
        let newSetting = SettingService.shared.toggleIsEnable()
        item.title = newSetting ? "無効にする" : "有効にする"
    }
    
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
        if SettingService.shared.isLaunchOnLogin {
            SettingService.shared.setEnableLaunchOnLogin(enabled: true)
        }
    }
}

