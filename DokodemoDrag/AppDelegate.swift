//
//  AppDelegate.swift
//  DokodemoDrag
//
//  Created by MuronakaHiroaki on 2021/08/19.
//

import Cocoa
import ServiceManagement
import os.log
import Defaults

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    static let launcherAppId = "hmu.DokodemoDragLauncher"
    @IBOutlet var statusBarMenu: NSMenu!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSLog("applicationDidFinishLaunching. AXIsProcessTrusted: \(AXIsProcessTrusted())")
        
        StatusBarItem.instance.statusMenu = statusBarMenu
        StatusBarItem.instance.refreshVisibility()
        
        checkLaunchOnLogin()
        
        MouseHookService.shared.start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        NSLog("applicationWillTerminate")
        MouseHookService.shared.stop()
    }
}

/// メニュー対する処理など
// TODO: 適切なクラスへ処理を移動させる
extension AppDelegate {
    
    /// ログイン時に自動起動のメニュー操作
    /// - Parameter item:
    @IBAction func toggleIsLaunchOnLogin(_ item: NSMenuItem) {
        let newSetting = SettingService.shared.toggleLaunchOnLogin()
        // TODO: 適切な箇所での処理
        item.state = newSetting ? .on : .off
    }
    
    /// 有効・無効のメニュー操作
    /// - Parameter item:
    @IBAction func toggleIsEnable(_ item: NSMenuItem) {
        let newSetting = SettingService.shared.toggleIsEnable()
        // TODO: 適切な箇所での処理
        item.title = newSetting ? "無効にする" : "有効にする"
    }
    
    
    /// 自動起動時の処理
    // NOTE: Rectangleより.
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

