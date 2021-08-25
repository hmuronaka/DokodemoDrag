//
//  AppDelegate.swift
//  DokodemoDrag
//
//  Created by Hiroaki Muronaka on 2021/08/19.
//  Copyright © 2021 Muronaka Hiroaki. All rights reserved.
//

import Cocoa
import ServiceManagement

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    static let launcherAppId = "hmu.DokodemoDragLauncher"
    @IBOutlet var authorizedMenu: NSMenu!
    @IBOutlet var unauthorizedMenu: NSMenu!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let isProcessTrusted = AXIsProcessTrusted()
        NSLog("applicationDidFinishLaunching. AXIsProcessTrusted: \(isProcessTrusted)")
        
        StatusBarItem.instance.statusMenu = isProcessTrusted ? authorizedMenu : unauthorizedMenu
        StatusBarItem.instance.refreshVisibility()
        checkLaunchOnLogin()
        
        if isProcessTrusted {
            MouseHookService.shared.start()
        }
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
        SettingService.shared.toggleLaunchOnLogin()
    }
    
    /// 有効・無効のメニュー操作
    /// - Parameter item:
    @IBAction func toggleIsEnable(_ item: NSMenuItem) {
        SettingService.shared.toggleIsEnable()
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
        
        // 以下のコメントはRectangleのまま
        // Even if we are already set up to launch on login, setting it again since macOS can be buggy with this type of launch on login.
        if SettingService.shared.isLaunchOnLogin {
            SettingService.shared.setEnableLaunchOnLogin(enabled: true)
        }
    }
}

